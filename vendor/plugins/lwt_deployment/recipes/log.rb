namespace :log do
  desc "Tail log files" 
  task :tail, :roles => :app do
    run "tail -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
      puts data
      break if stream == :err    
    end
  end
end