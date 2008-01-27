desc "Console" 
task :console, :roles => :app do
  input = ''
  run "cd #{current_path} && ./script/console #{rails_env}" do |channel, stream, data|
    next if data.chomp == input.chomp || data.chomp == ''
    print data
    channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
  end
end