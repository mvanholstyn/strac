task :ci => [:spec, :stories]

task :stories do
  system "ruby stories/all.rb"
end
