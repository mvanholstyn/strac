require File.dirname(__FILE__) + '/../test_helper'
require 'iterations_controller'

# Re-raise errors caught by the controller.
class IterationsController; def rescue_action(e) raise e end; end

class IterationsControllerTest < Test::Unit::TestCase
  fixtures :iterations, :projects

  def setup
    @controller = IterationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    login_as( 'mvanholstyn' )
    @project = projects( :one )
  end

  def test_should_get_index
    get :index, :project_id=>@project.id
    assert_response :success
    assert assigns(:iterations)
  end

  def test_should_get_new
    get :new, :project_id=>@project.id
    assert_response :success
  end

  def test_should_create_iteration
    old_count = Iteration.count
    post :create, :iteration => { 
      :start_date => Date.today, 
      :end_date => Date.today+1,
      :name => "Iteration 1" }, :project_id=>@project.id
    assert_equal old_count+1, Iteration.count

    assert_redirected_to iteration_path( @project, assigns(:iteration))
  end

  def test_should_show_iteration
    get :show, :id => 1, :project_id=>@project.id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1, :project_id=>@project.id
    assert_response :success
  end

  def test_should_update_iteration
    put :update, :id => 1, :project_id=>@project.id, :iteration => { :budget=>'25' }
    assert_redirected_to iteration_path( @project, assigns(:iteration))
  end

  def test_should_destroy_iteration
    old_count = Iteration.count
    delete :destroy, :project_id=>@project.id, :id => 1
    assert_equal old_count-1, Iteration.count

    assert_redirected_to iterations_path
  end
end
