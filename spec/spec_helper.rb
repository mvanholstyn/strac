# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails'

require File.expand_path(File.dirname(__FILE__) + "/../spec/spec_helpers/assertions")
require File.expand_path(File.dirname(__FILE__) + "/../spec/spec_helpers/association_matcher")
require File.expand_path(File.dirname(__FILE__) + "/../spec/spec_helpers/model_generation")

dir = File.expand_path(File.dirname(__FILE__))
Dir[ dir + "/spec_helpers/*.rb"].each do |f|
  require f
end

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  config.include HaveAssociationMatcher 
  config.global_fixtures = :statuses

  # You can declare fixtures for each behaviour like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so here, like so ...
  #
  #   config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.


end

