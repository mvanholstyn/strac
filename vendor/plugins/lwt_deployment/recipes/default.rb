require 'etc'
# Load the mongrel_cluster tasks
require 'mongrel_cluster/recipes'

# You must set :repository_path and :application in your Capfile

# Sets the RAILS_ENV for this deployment. Default: staging
set(:rails_env, ENV["RAILS_ENV"] ? ENV["RAILS_ENV"].to_sym : :staging)

# Sets the environment for the mongrel cluster
set(:mongrel_environment) { rails_env }

# Sets the location to deploy from. Default: trunk
if tag = ENV["TAG"]
  set(:repository_path, "tags/#{tag}")
elsif branch = ENV["BRANCH"]
  set(:repository_path, "branches/#{branch}")
else
  set(:repository_path, :trunk)
end

# Sets the repository host. This MUST be set.
set(:repository_host) { abort "Please specify the host for your repository, set :repository_host, 'svn.example.com'" }

# Sets the repository to deploy from. Default: http://#{repository_host}/#{application}/#{repository_path}
set(:repository) { "http://#{repository_host}/#{application}/#{repository_path}" }

# Sets the user to deploy as. Default: #{application}
set(:user) { application }

# Sets the user to run mongrel processes as
set(:mongrel_user) { application }

# Sets the group to run mongrel processes as
set(:mongrel_group) { application }

# Sets the SCM user to deploy as. Default: #{Etc.getlogin}
set(:scm_username, Etc.getlogin)

# Prompt for SCM password
set(:scm_prefer_prompt, true)

# Sets the location to deploy to. Default: /var/www/#{application}/#{rails_env}
set(:deploy_to) { "/var/www/#{application}/#{rails_env}" }

# Sets the extra paths to symlink.
set(:symlinks, [])

set(:use_sudo, false)

# Sets the mongrel_cluster config location. Default: /etc/mongrel_cluster/#{application}/#{rails_env}.yml
set(:mongrel_conf) { "/etc/mongrel_cluster/#{application}/#{rails_env}.yml" }

[:production, :staging].each do |environment|
  desc "Runs the following task(s) in the #{environment} environment" 
  task environment do
    set(:rails_env, environment)
  end
end

namespace :db do
  desc "Run the mysql shell for the current environment using the configuration defined in database.yml"
  task :shell, :roles => :db, :only => { :primary => true } do
    input = ''
    run "cd #{current_path} && rake #{rails_env} db:shell" do |channel, stream, data|
      next if data.chomp == input.chomp || data.chomp == ''
      print data
      channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
    end
  end
  
  namespace :fixtures do
    desc "Load fixtures into the current environment's database. Load specific fixtures using FIXTURES=x,y"
    task :import, :roles => :db, :only => { :primary => true } do
      fixtures = ENV["FIXTURES"] ? "FIXTURES=#{ENV["FIXTURES"]}" : ""
      run "cd #{current_path} && rake #{rails_env} spec:db:fixtures:load #{fixtures}"
    end
  end
end

desc "Console" 
task :console, :roles => :app do
  input = ''
  run "cd #{current_path} && ./script/console #{rails_env}" do |channel, stream, data|
    next if data.chomp == input.chomp || data.chomp == ''
    print data
    channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
  end
end

namespace :log do
  desc "Tail log files" 
  task :tail, :roles => :app do
    run "tail -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
      puts data
      break if stream == :err    
    end
  end
end

namespace :deploy do
  desc "Default deploy task: updates code, disables web, updates symlinks, migrates, restarts web server, enables web, cleans up old releases"
  task :default do
    transaction do
      update_code
      web.disable
      symlink
      # backup_database
      migrate
    end

    restart
    web.enable
    cleanup
  end
  
  desc "Symlinks config/database.yml and all entries in symlinks from \#{shared_path}/\#{symlink} to \#{current_path}/\#{symlink}."
  task :symlink_extras, :except => { :no_release => true } do
    run "rm -f #{current_path}/config/database.yml && ln -s #{shared_path}/config/database.yml #{current_path}/config/database.yml"
    symlinks.each do |symlink|
      run "rm -f #{current_path}/#{symlink} && ln -s #{shared_path}/#{symlink} #{current_path}/#{symlink}"
    end 
  end
  after "deploy:symlink", "deploy:symlink_extras"
    
  task :setup_extras, :except => { :no_release => true } do
    require 'erb'
    
    # Copy over database.yml template
    run "umask 02 && mkdir -p #{shared_path}/config"
    template = File.read(File.join(File.dirname(__FILE__), "..", "templates", "config", "database.yml"))
    result = ERB.new(template).result(binding)
    put result, "#{shared_path}/config/database.yml", :mode => 0644
    
    # Copy over a mongrel_cluster config file
    run "umask 02 && mkdir -p /etc/mongrel_cluster"
    mongrel.cluster.configure
    
    # Copy over a virtual host config file
    # run "umask 02 && mkdir -p /etc/apache2/sites-available /etc/apache2/sites-enabled"
    # template = File.read(File.join(File.dirname(__FILE__), "..", "templates", "config", "virtual_host.conf"))
    # result = ERB.new(template).result(binding)
    # put result, "/etc/apache2/sites-available/#{application}-#{rails_env}.conf", :mode => 0644
    # run "rm -f /etc/apache2/sites-enabled/#{application}-#{rails_env}.conf && ln -s /etc/apache2/sites-available/#{application}-#{rails_env}.conf /etc/apache2/sites-enabled/#{application}-#{rails_env}.conf"
  end
  after "deploy:setup", "deploy:setup_extras"
end

# need root to make 
#  * /etc/mongrel_cluster
#  * deploy_to

#dependencies

# task :backup_database, :roles => :db, :only => { :primary => true } do
#   run "mysqldump -u ? -p? ? > #{shared_path}/backups/#{Time.now.strftime("%Y%m%d%H%M%S")}.sql"
# end
  
# task :helper_demo do
#   buffer = render("maintenance.rhtml", :deadline => ENV['UNTIL'])
#   put buffer, "#{shared_path}/system/maintenance.html", :mode => 0644
#   delete "#{shared_path}/system/maintenance.html"
# end

# task :copy_production_to_development, :roles => :db, :only => { :primary => true } do
#   run "mysqldump -u ? -p? ? | mysql -u ? -p? ?"
# end
