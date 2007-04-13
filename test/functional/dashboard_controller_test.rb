require File.dirname(__FILE__) + '/../test_helper'
require 'dashboard_controller'

# Re-raise errors caught by the controller.
class DashboardController; def rescue_action(e) raise e end; end

class DashboardControllerTest < Test::Unit::TestCase
  
  def setup
    @controller = DashboardController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_index_page_should_have_project_links
    login_as 'zdennis'

    get :index
    assert_response :success
        
    # main project list
    assert_select "div#content > h2 > a[href='/projects/1']", "MyString"
    
    # sidebar project list list
    assert_select "div#sidebar > ul > li > a[href='/projects/1']", "MyString" 

  end
end
