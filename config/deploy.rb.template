set :application, "strac"
# My repository does not follow my own standard convention...
# set :repository_host, "svn.example.com"
set :repository, "http://rails.lotswholetime.com/svn/#{application}/#{repository_path}"

# Used for web.disable and web.enable
role :web, "lotswholetime.com"
# Used for deploy.start, deploy.stop, deploy.restart
role :app, "lotswholetime.com"
# Used for deploy.migrate
role :db, "lotswholetime.com", :primary => true

# This application deploys to my home directory
set :deploy_to, "/home/mvanholstyn/websites/strac.lotswholetime.com"

# This application does not have staging
set(:rails_env, :production)

set(:user, Etc.getlogin)

namespace :deploy do
  # This application is not on mongrel...
  desc "Start apache"
  task :start do
    sudo "apache2ctl start"
  end
  
  desc "Stop apache"
  task :stop do
    sudo "apache2ctl stop"
  end
  
  desc "Restart apache"
  task :restart do
    sudo "apache2ctl restart"
  end
  
  # This application needs special permissions
  desc "Update permissions"
  task :update_permissions do
    sudo "chown -R mvanholstyn:www-data #{shared_path}/.."
    run "chmod -R 770 #{shared_path}/.."
  end
  after "deploy:symlink", "deploy:update_permissions"
end