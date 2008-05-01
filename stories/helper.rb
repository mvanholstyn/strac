ENV["RAILS_ENV"] = "test"

dir = File.expand_path(File.dirname(__FILE__))

require dir + "/../config/environment"
require 'spec/rails/story_adapter'

require dir + "/../spec/spec_helpers/model_generation"

Dir[dir + "/story_helpers/**/*.rb"].each { |f| require f }
Dir["#{dir}/steps/**/*.rb"].each { |f| require f }

Generate.group(:name => "Developer")

class RailsStory
  include ActionView::Helpers::RecordIdentificationHelper
end