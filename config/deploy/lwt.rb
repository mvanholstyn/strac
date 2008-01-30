set :application, "strac"
set :repository, "http://rails.lotswholetime.com/svn/#{application}/#{repository_path}"

role :web, "strac.lotswholetime.com"
role :app, "strac.lotswholetime.com"
role :db, "strac.lotswholetime.com", :primary => true

set :deploy_to, "/home/mvanholstyn/websites/strac.lotswholetime.com"

set(:rails_env, :production)

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