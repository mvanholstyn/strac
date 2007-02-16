require File.dirname(__FILE__) + '/../test_helper'
require 'stories_controller'

# Re-raise errors caught by the controller.
class StoriesController; def rescue_action(e) raise e end; end

#TODO: Do I want to update the generated functionals to be more robust?
class StoriesControllerTest < Test::Unit::TestCase
  fixtures :stories

  def setup
    @controller = StoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:stories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_story
    old_count = Story.count
    post :create, :story => { :summary => "My Summary", :description => "My Description" }
    assert_equal old_count+1, Story.count

    assert_redirected_to stories_path
  end

  def test_should_show_story
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_story
    put :update, :id => 1, :story => { }
    assert_redirected_to stories_path
  end

  def test_should_destroy_story
    old_count = Story.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Story.count

    assert_redirected_to stories_path
  end

  #TODO: This could be far more robust
  def test_post_to_reorder_should_attempt_to_reorder
    Story.expects( :reorder ).with( [ 2, 1 ], :iteration_id => nil ).returns( true )

    post :reorder, :iteration_nil => [ 2, 1 ]
    assert_response :success
  end
end
