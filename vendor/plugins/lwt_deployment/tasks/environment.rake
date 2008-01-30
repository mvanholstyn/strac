["production", "staging"].each do |environment|
  desc "Runs the following task(s) in the #{environment} environment" 
  task environment do
    RAILS_ENV = ENV['RAILS_ENV'] = environment
  end
end

Dir[File.join(RAILS_ROOT, "config", "deploy", "*.rb")].each do |deploy_file|
  task deploy_file.gsub(".rb", "") do
    load deploy_file
  end
end