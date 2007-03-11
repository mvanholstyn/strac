require File.dirname(__FILE__) + '/../test_helper'
require 'stories_controller'

# Re-raise errors caught by the controller.
class StoriesController; def rescue_action(e) raise e end; end

#TODO: Do I want to update the generated functionals to be more robust?
class StoriesControllerTest < Test::Unit::TestCase
  fixtures :stories, :projects

  def setup
    @controller = StoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  
    @project = projects( :one )
    login_as 'mvanholstyn'
  end

  def test_should_get_index
    get :index, :project_id=>@project.id
    assert_response :success
  end

  def test_should_get_new
    get :new, :project_id=>@project.id
    assert_response :success
  end

  def test_should_create_story
    old_count = Story.count
    post :create, :story => { :summary => "My Summary", :description => "My Description" }, :project_id=>@project.id
    assert_equal old_count+1, Story.count

    assert_template 'create.rjs'
    assert_response :success
  end

  def test_should_show_story
    get :show, :id => 1, :project_id=>@project.id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1, :project_id=>@project.id
    assert_response :success
  end

  def test_should_update_story
    put :update, :id => 1, :story => { }, :project_id=>@project.id    
    assert_template 'update.rjs'
    assert_response :success
  end

  #TODO: This could be far more robust
  def test_post_to_reorder_should_attempt_to_reorder
    Story.expects( :reorder ).with( [ 2, 1 ], :iteration_id => nil ).returns( true )

    post :reorder, :iteration_nil => [ 2, 1 ], :project_id=>@project.id
    assert_response :success
  end
end
