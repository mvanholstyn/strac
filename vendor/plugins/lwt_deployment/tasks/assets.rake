namespace :assets do
  namespace :backup do  
    desc "Creates a backup of the assets."
    task :create => ["backup:directory", "backup:version"] do
      backup_directory = "#{ENV['BACKUP_DIR']}/#{ENV['BACKUP_VERSION']}"

      ENV["BACKUPS"].to_s.split(",").each do |backup|
        if File.exist?(backup)
          FileUtils.mkdir_p "#{backup_directory}/#{File.dirname(backup)}"
          FileUtils.cp_r backup, "#{backup_directory}/#{File.dirname(backup)}"
        end
      end
    end
  end
end
