ENV["RAILS_ENV"] = "test"

dir = File.expand_path(File.dirname(__FILE__))

require dir + "/../config/environment"
require 'spec/rails/story_adapter'

require dir + "/../spec/spec_helpers/model_generation"
require dir + "/../spec/spec_helpers/string_extensions"

Dir[dir + "/helpers/*.rb"].each do |f|
  require f
end

Generate.group("Developer")
