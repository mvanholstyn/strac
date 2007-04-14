require File.dirname(__FILE__) + '/../test_helper'
require 'comments_controller'

# Re-raise errors caught by the controller.
class CommentsController; def rescue_action(e) raise e end; end

class CommentsControllerTest < Test::Unit::TestCase
  
  def setup
    @controller = CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @story = stories(:one)
    @project = projects(:one)
    login_as 'zdennis'
  end

  def test_should_get_index
    get :index, :story_id=>@story.id, :project_id=>@project.id
    assert_response :success
  end

  def test_should_get_new
    get :new, :story_id=>@story.id, :project_id=>@project.id
    assert_response :success
  end

  def test_should_create_comment
    old_count = Comment.count
    post :create, :comment => { :content=>"test comment", :commenter_id=>1 }, :story_id=>@story.id, :project_id=>@project.id
    assert_equal old_count+1, Comment.count

    assert_template 'create.rjs'
    assert_response :success
  end

  def t1est_should_show_comment
    get :show, :id => 1, :story_id=>@story.id, :project_id=>@project.id
    assert_response :success
  end

end
