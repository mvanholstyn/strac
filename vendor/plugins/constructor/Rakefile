require 'rubygems'
require 'hoe'
require './lib/constructor.rb'
require 'spec/rake/spectask'


desc 'Default: run specs'
task :default => :spec
Hoe.new('constructor', CONSTRUCTOR_VERSION) do |p|
  p.rubyforge_name = 'atomicobjectrb'
  p.author = 'Atomic Object'
  p.email = 'dev@atomicobject.com'
  p.summary = 'Declarative, named constructor arguments.'
  p.description =  p.paragraphs_of('README.txt', 2).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 1).first.gsub(/\* /,'').split(/\n/)
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

desc 'Run constructor specs'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['specs/*_spec.rb']
  t.spec_opts << '-c -f s'
end
