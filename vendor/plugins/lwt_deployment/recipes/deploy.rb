namespace :deploy do
  desc "Default deploy task: updates code, disables web, updates symlinks, backup db, backup assets, migrates, restarts web server, enables web, cleans up old releases"
  task :default do
    transaction do
      update_code
      web.disable
      symlink
      backup.create if backup_on_deploy
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
end