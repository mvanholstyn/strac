require File.join(RAILS_ROOT, '/vendor/plugins/rspec/lib/spec/rake/spectask')

task :cruise do
  Rake::Task["db:migrate"].invoke
  Rake::Task["cruise_spec"].invoke
end

Spec::Rake::SpecTask.new(:cruise_spec) do |t|
   t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
   t.spec_files = FileList['spec/**/*_spec.rb']
end