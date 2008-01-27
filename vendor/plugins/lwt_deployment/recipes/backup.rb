namespace :backup do
  desc "Creates a back of the database and assets."
  task :create, :roles => :db, :only => {:primary => true} do
    run "cd #{current_path} && rake #{rails_env} backup:create BACKUP_DIR=#{shared_path}/backups BACKUPS=#{backups.join(',')}"
  end
end