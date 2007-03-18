require File.dirname(__FILE__) + '/../test_helper'
require 'textile_controller'

# Re-raise errors caught by the controller.
class TextileController; def rescue_action(e) raise e end; end

class TextileControllerTest < Test::Unit::TestCase
  def setup
    @controller = TextileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
