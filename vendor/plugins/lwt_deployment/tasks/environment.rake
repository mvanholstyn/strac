["production", "staging"].each do |environment|
  desc "Runs the following task(s) in the #{environment} environment" 
  task environment do
    RAILS_ENV = ENV['RAILS_ENV'] = environment
  end
end
