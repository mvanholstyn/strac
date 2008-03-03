config.after_initialize do
  if RAILS_ENV == "test"
    require 'spec/matchers'
    require File.expand_path(File.dirname(__FILE__) + "/lib/rspec_on_rails_render_and_receive")
  end
end