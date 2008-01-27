[:production, :staging].each do |environment|
  desc "Runs the following task(s) in the #{environment} environment" 
  task environment do
    set(:rails_env, environment)
  end
end