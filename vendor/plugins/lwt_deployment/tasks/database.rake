namespace :db do
  namespace :data do
    desc "Load seed fixtures (from db/fixtures) into the current environment's database."
    task :seed => :environment do
      require 'active_record/fixtures'
      Dir.glob(RAILS_ROOT + '/db/fixtures/*.yml').each do |file|
        Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
      end
    end
  end
  
  # Adding db:data:seed to be run automatically when db:migrate is run
  task :migrate do
    Rake::Task["db:data:seed"].invoke
  end

  desc "Run the mysql shell for the current environment using the configuration defined in database.yml"
  task :shell do
    configuration = YAML.load_file(File.join(RAILS_ROOT, 'config', 'database.yml'))[RAILS_ENV]
    case configuration["adapter"]
      when "mysql"
        command = ["mysql"]
        command << "-u#{configuration['username']}"   if configuration['username']
        command << "-p'#{configuration['password']}'" if configuration['password']
        command << "-h#{configuration['host']}"       if configuration['host']
        command << "-P#{configuration['port']}"       if configuration['port']
        command << configuration['database']          if configuration['database']
      when "postgresql"
        ENV['PGHOST']     = configuration["host"]     if configuration["host"]
        ENV['PGPORT']     = configuration["port"]     if configuration["port"]
        ENV['PGPASSWORD'] = configuration["password"] if configuration["password"]
        command = ["psql", "-U #{configuration['username']}", configuration['database']]
      when "sqlite"
        command = ["sqlite", configuration["database"]]
      when "sqlite3"
        command = ["sqlite3", configuration["database"]]
      else
        raise "not supported for this database type"
    end
    system command.join(" ")
  end
  
  namespace :backup do
    task :latest => "backup:directory" do
      last = Dir["#{ENV['BACKUP_DIR']}/*/"].sort.last
      puts ENV['BACKUP_VERSION'] ||= File.basename(last) if last
    end
  
    task :environment => ["backup:directory", "backup:version"] do
      db_backup_directory = "#{ENV['BACKUP_DIR']}/#{ENV['BACKUP_VERSION']}/db"
      fixtures_backup_directory = "#{db_backup_directory}/fixtures"
      FileUtils.mkdir_p db_backup_directory
      FileUtils.mkdir_p fixtures_backup_directory
      ENV['FIXTURES_DIR'] = fixtures_backup_directory
      ENV['SCHEMA'] = "#{db_backup_directory}/schema.rb"
    end
  
    desc "Creates a backup of the database."
    task :create => [:environment, 'db:fixtures:dump', 'db:schema:dump']

    desc "Restores a backup of the database."
    task :restore => [:latest, :environment, 'db:schema:load', 'db:fixtures:load']
  end
end

# http://matthewbass.com/2007/03/07/overriding-existing-rake-tasks/
Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end
 
def remove_task(task_name)
  Rake.application.remove_task(task_name)
end

remove_task "db:fixtures:load"

namespace :db do
  namespace :fixtures do
    desc "Load fixtures into the current environment's database.  Load specific fixtures using FIXTURES=x,y"
    task :load => :environment do
      require 'active_record/fixtures'
      fixtures_dir = ENV['FIXTURES_DIR'] || 'test/fixtures'
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(fixtures_dir, '*.{yml,csv}'))).each do |fixture_file|
        Fixtures.create_fixtures(fixtures_dir, File.basename(fixture_file, '.*'))
      end
    end
    
    desc "Create YAML fixtures from data in the current environment's database. Dump specific tables using TABLES=x[,y,z]."
    task :dump => :environment do
      skip_tables = ["schema_info", "sessions"] 
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      fixtures_dir = ENV['FIXTURES_DIR'] || 'test/fixtures'
      tables = ENV['TABLES'] || ActiveRecord::Base.connection.tables
      sql = "SELECT * FROM %s LIMIT %d OFFSET %d"
      limit = 50
      (tables - skip_tables).each do |table_name| 
        i = "000"
        offset = 0
        File.open("#{fixtures_dir}/#{table_name}.yml", 'w' ) do |file|
          while !(data = ActiveRecord::Base.connection.select_all(sql % [table_name, limit, offset])).empty?
            data.each do |record|
              file.write({"#{table_name}_#{i.succ!}" => record}.to_yaml.gsub(/^---.*\n/, ''))
            end
            offset += limit
          end
        end
      end
    end
  end
end
