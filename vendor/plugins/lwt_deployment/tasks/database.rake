namespace :db do
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
end