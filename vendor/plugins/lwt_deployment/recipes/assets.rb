namespace :assets do
  namespace :backup do
    desc "Creates a back of the assets."
    task :create, :roles => :db, :only => {:primary => true} do
      run "cd #{current_path} && rake #{rails_env} assets:backup:create BACKUP_DIR=#{shared_path}/backups BACKUPS=#{backups.join(',')}"
    end
  end
end