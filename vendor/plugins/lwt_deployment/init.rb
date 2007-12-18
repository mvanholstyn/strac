Dir[File.join(RAILS_ROOT, *%w[vendor gems *])].each do |gem_directory|
  gem_lib_directory = File.join(gem_directory, 'lib')
  if File.directory?(gem_lib_directory)
    $LOAD_PATH.unshift(gem_lib_directory) 
    Dependencies.load_paths << gem_lib_directory
    Dependencies.load_once_paths << gem_lib_directory
  end
end


# if %w(development test).include? RAILS_ENV
#   config.load_paths.delete_if { |f| f =~ /RubyInline|image_science/ }
# end  