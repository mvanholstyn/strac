ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails/story_adapter'
require File.expand_path(File.dirname(__FILE__) + "/../spec/spec_helpers/model_generation")
require File.expand_path(File.dirname(__FILE__) + "/../spec/spec_helpers/string_extensions")

def click_link(path)
  select_link(path).follow
end