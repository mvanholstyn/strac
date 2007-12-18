# TODO: SVN integration
namespace :gems do
  task :freeze do
    raise "No gem specified" unless gem_name = ENV['GEM']

    require 'rubygems'
    require 'activesupport'
    Gem.manage_gems
    
    if version = ENV['VERSION']
      gem = Gem.cache.search(gem_name, "= #{version}").first
    else
      gem = Gem.cache.search(gem_name).sort_by(&:version).last
    end
    
    if gem
      version ||= gem.version.version
    else
      raise "Could not find the gem '#{gem_name}' #{version}"
      # TODO: Auto install the gem?
      # tmp_dir = File.join(RAILS_ROOT, 'tmp', 'gems')
      # begin
      #   if version
      #     Gem::GemRunner.new.run ["install", "#{gem_name}", "-v", "#{version}", "-i", "#{tmp_dir}/gems", "--no-rdoc", "--include-dependencies"]
      #   else
      #     Gem::GemRunner.new.run ["install", "#{gem_name}", "-i", "#{tmp_dir}", "--no-rdoc", "--include-dependencies"]
      #   end
      # rescue
      #   puts "ERROR. Failed to download #{gem_name}."
      #   exit(1)
      # end
      # ENV["GEM_HOME"] = "#{tmp_dir}/gems"
      # gem = Gem::SourceIndex.from_installed_gems("#{tmp_dir}/gems/specifications").search(gem_name).first
    end
    
    vendor_gems_directory = File.join(RAILS_ROOT, 'vendor', 'gems')
    mkdir_p vendor_gems_directory
    
    chdir vendor_gems_directory do
      # TODO: Remove old versions...
      gem.dependencies.each do |dependency|
        Gem::GemRunner.new.run ["unpack", "-v", "#{dependency.version_requirements}", dependency.name ]
      end
      Gem::GemRunner.new.run ["unpack", "-v", "=#{gem.version}", gem_name ]
    end
  end

  task :unfreeze do
    raise "No gems specified" unless gem_names = ENV['GEMS']
    Dir[File.join(RAILS_ROOT, *%W[vendor gems {#{gem_names}}-*])].each do |gem_directory|
      rm_rf gem_directory
    end
  end

  task :update do
    require 'rubygems'
    require 'activesupport'
    Gem.manage_gems
    
    Dir[File.join(RAILS_ROOT, *%w[vendor gems *])].each do |gem_directory|
      match = File.basename(gem_directory).match(/^(.*)-(\d+(?:\.\d+)*)$/)
      gem_name, version = match[1], match[2]
      
      if newest_gem = Gem.cache.search(gem_name, "> #{version}").sort_by(&:version).last
        ENV['GEM'] = gem_name
        Rake::Task["gems:freeze"].invoke
      end
    end
  end
end