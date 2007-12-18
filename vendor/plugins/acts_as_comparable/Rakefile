require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc "Default Task"
task :default => :test 

desc "Test acts_as_comparable"
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end

desc "Generate documentation for acts_as_comparable"
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "acts_as_comparable"
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
