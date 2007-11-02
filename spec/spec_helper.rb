# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails'
require File.expand_path(File.dirname(__FILE__) + "/../test/helpers/assertions")

Dir[File.expand_path(File.dirname(__FILE__) + "/../spec/spec_helpers/*.rb")].each do |file|
  require file
end

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

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
  
  def login_as(user)
    if user.is_a?(String) || user.is_a?(Symbol)
      user = users(user)
    end
    @request.session[:current_user_id] = user.id
    User.current_user = user
  end 

  def mock_new_model(clazz)
    model = mock_model(clazz)
    model.stub!(:id)
    model.stub!(:to_param)
    model.stub!(:new_record?).and_return(true)
    model
  end
end

module Spec::DSL::Behaviour
  alias_method :they, :it
  alias_method :is, :it
end

def stub(name, attrs={})
  mock = mock(name)
  returning mock do |mock|
    attrs.each_pair do |key, val|
      mock.stub!(key).and_return(val)
    end
  end
end
