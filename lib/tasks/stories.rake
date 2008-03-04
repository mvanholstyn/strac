namespace :spec do
  task :stories do
    system "ruby stories/all.rb"
  end
end

task :spec do
  Rake::Task['spec:stories'].invoke
end
