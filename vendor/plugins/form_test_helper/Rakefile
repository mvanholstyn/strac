require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the form_test_helper plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the form_test_helper plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'FormTestHelper'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "cruisecontrol.rb"
task :cruise do  
  `rm -fr ../dummy_rails_project/vendor/plugins/form_test_helper`
  `mkdir -p ../dummy_rails_project/vendor/plugins/form_test_helper`  
  `cp -fr * ../dummy_rails_project/vendor/plugins/form_test_helper/`  
  Dir.chdir('../dummy_rails_project/')  
  `rake rails:freeze:edge`  
  Dir.chdir('vendor/plugins/form_test_helper')  
  Rake::Task[:test].invoke
end