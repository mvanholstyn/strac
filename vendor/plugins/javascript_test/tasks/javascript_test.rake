def js_setup(test_runner)
  test_runner.mount("/", RAILS_ROOT)
  test_runner.mount("/test", RAILS_ROOT+'/test')
  
  test_str = ENV["TESTS"] || ''
  tests = test_str.split ' '

  if tests.empty?
    test_dir = File.expand_path(File.join(RAILS_ROOT, 'test/javascript'))
    tests = Dir["#{test_dir}/*_test.js"]
  end

  tests.each do |f|
    test_runner.run File.basename(f).chomp('_test.js') 
  end
end

desc "Run tests for JavaScripts"
task 'test:javascripts' => :environment do
  r = JavaScriptTest::Runner.new do |t| 
    js_setup(t)
    
    t.browser(:firefox)
  end
  raise "JS tests failed" unless r.successful?
end
task "test:js" => ["test:javascripts"]

%w{safari firefox ie konqueror}.each do |browser|
  desc "Run tests for JavaScripts in #{browser}"
  task "test:javascripts:#{browser}" => :environment do
    r = JavaScriptTest::Runner.new do |t| 
      js_setup(t)
    
      t.browser(browser.to_sym)
    end
    raise "JS tests failed" unless r.successful?
  end
  
  task "test:js:#{browser}" => ["test:javascripts:#{browser}"]
end

