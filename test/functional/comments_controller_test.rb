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

  def test_should_list_comments
    get :index, :story_id=>@story.id, :project_id=>@project.id
    assert_response :success
    
    is_rendering_inline_comments = assigns(:is_rendering_inline_comments)
    assert_equal false, is_rendering_inline_comments, "Inline comments shouldn't be rendered!"
  end
  
  def test_should_should_list_comments_with_is_rendering_popup_comments_as_false
    get :index, :story_id=>@story.id, :project_id=>@project.id, :inline=>'false'
    assert_response :success

    is_rendering_inline_comments = assigns(:is_rendering_inline_comments)
    assert_equal false, is_rendering_inline_comments, "Inline comments shouldn't be rendered!"
  end
  
  def test_should_should_list_comments_with_is_rendering_popup_comments_as_false
    get :index, :story_id=>@story.id, :project_id=>@project.id, :inline=>'true'
    assert_response :success

    is_rendering_inline_comments = assigns(:is_rendering_inline_comments)
    assert is_rendering_inline_comments, "Inline comments should be rendered!"
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
  
  def test_should_fail_creating_a_comment
    old_count = Comment.count
    xhr :post, :create, :comment => {}, :story_id=>@story.id, :project_id=>@project.id
    assert_equal old_count, Comment.count
    
    comment = assigns(:comment)
    assert comment, "should have had a comment!"
    assert comment.errors.on(:content), "should have had an error on content"
    assert_equal "can't be blank", comment.errors.on(:content), "should have had an error on content"
    
    assert_template 'new.rjs'
  end

  def t1est_should_show_comment
    get :show, :id => 1, :story_id=>@story.id, :project_id=>@project.id
    assert_response :success
  end

end
