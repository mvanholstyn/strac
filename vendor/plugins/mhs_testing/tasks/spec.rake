namespace :spec do
  rspec_base = File.expand_path(File.join(RAILS_ROOT, *%w[vendor plugins rspec lib]))
  $LOAD_PATH.unshift(rspec_base) if File.exist?(rspec_base)
  require 'spec/rake/spectask'
  require 'spec/translator'

  desc "Run the specs under spec/selenium"
  Spec::Rake::SpecTask.new(:selenium) do |t|
    t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
    t.spec_files = FileList["spec/selenium/**/*_spec.rb"]
  end
  
  namespace :selenium do
    namespace :server do
      desc "start the selenium server"
      task :start => :environment do
        Selenium::Server.connect!
      end
      
      desc "stop the selenium server"
      task :stop => :environment do
        Selenium.configuration.stop_selenium_server = true
        Selenium.configuration.stop_test_server = true
        Selenium::Server.disconnect!
      end
      
      desc "restart the selenium server"
      task :restart do
        Rake::Task["spec:selenium:server:stop"].invoke
        sleep 2
        Rake::Task["spec:selenium:server:start"].invoke
      end
    end
  end
end
