# Lets load up a rails environment
plugin_spec_directory = File.expand_path(File.dirname(__FILE__))
unless defined?(RAILS_ROOT)
 RAILS_ROOT = ENV["RAILS_ROOT"] || File.join(plugin_spec_directory, "../../../..")
end
require File.join(RAILS_ROOT, "spec", "spec_helper")

class String
  def to_regexp
    Regexp.new Regexp.escape(self), Regexp::IGNORECASE
  end
end
    
