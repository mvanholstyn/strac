namespace :backup do
  task :directory do
    ENV['BACKUP_DIR'] ||= 'backups'
  end
  
  task :version do
    ENV['BACKUP_VERSION'] ||= Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
  
  task :create do
    Rake::Task["db:backup:create"].invoke
    Rake::Task["assets:backup:create"].invoke
  end
end