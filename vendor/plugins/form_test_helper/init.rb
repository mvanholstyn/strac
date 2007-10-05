if RAILS_ENV == 'test'

  require "form_test_helper"
  Test::Unit::TestCase.send :include, FormTestHelper

  # I have to include FormTestHelper this way or it loads from gems and not vendor:
  module ActionController::Integration
    class Session
      include FormTestHelper
    end
  end

end