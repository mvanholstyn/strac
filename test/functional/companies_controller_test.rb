require File.dirname(__FILE__) + '/../test_helper'
require 'companies_controller'

# Re-raise errors caught by the controller.
class CompaniesController; def rescue_action(e) raise e end; end

class CompaniesControllerTest < Test::Unit::TestCase
  fixtures :companies

  def setup
    @controller = CompaniesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:companies)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_company
    old_count = Company.count
    post :create, :company => { }
    assert_equal old_count+1, Company.count
    
    assert_redirected_to company_path(assigns(:company))
  end

  def test_should_show_company
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_company
    put :update, :id => 1, :company => { }
    assert_redirected_to company_path(assigns(:company))
  end
  
  def test_should_destroy_company
    old_count = Company.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Company.count
    
    assert_redirected_to companies_path
  end
end
