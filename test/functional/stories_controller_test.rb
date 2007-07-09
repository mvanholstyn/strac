require File.dirname(__FILE__) + '/../test_helper'
require 'stories_controller'

# Re-raise errors caught by the controller.
class StoriesController; def rescue_action(e) raise e end; end

#TODO: Do I want to update the generated functionals to be more robust?
class StoriesControllerTest < Test::Unit::TestCase

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

    assert_template 'create'
    assert_response :success
  end

  def test_should_show_story
    get :show, :id => 1, :project_id=>@project.id
    assert_response :success
    
    assert_template 'show'
  end

  def test_should_get_edit
    get :edit, :id => 1, :project_id=>@project.id
    assert_response :success
  end

  def test_should_update_story
    put :update, :id => 1, :story => { }, :project_id=>@project.id    
    assert_template 'update'
    assert_response :success
  end
  
  def test_take_a_story_with_success    
    put :take, :id => 1, :story => {}, :project_id => @project.id
    assert_response :success
    
    story = assigns(:story)
    assert story

    assert @response.body =~ /\\\"#{story.summary}\\\" was successfully taken\./
    assert @response.body =~ /Release from Mark VanHolstyn/
  end
  
  def test_take_a_story_that_fails
    Story.expects(:find).returns( Story.new(:summary=>"blah") )
    
    put :take, :id => 1, :story => {}, :project_id => @project.id
    assert_response :success
    
    story = assigns(:story)
    assert story

    assert @response.body =~ /\\\"#{story.summary}\\\" was not successfully taken\./
  end
  
  def test_release_a_story_with_success    
    put :release, :id => 1, :story => {}, :project_id => @project.id
    assert_response :success
    
    story = assigns(:story)
    assert story

    assert @response.body =~ /\\\"#{story.summary}\\\" was successfully released\./
    assert @response.body =~ /Take this story/
  end
  
  def test_take_a_release_that_fails
    Story.expects(:find).returns( Story.new(:summary=>"blah") )
    
    put :release, :id => 1, :story => {}, :project_id => @project.id
    assert_response :success
    
    story = assigns(:story)
    assert story

    assert @response.body =~ /\\\"#{story.summary}\\\" was not successfully released\./
  end
  
  def test_should_update_story_status
    story_mock = Story.new
    story_mock.expects( :status_id= ).with( 1 )
    story_mock.expects( :save ).returns( true )
    Story.expects( :find ).returns( story_mock )
    
    put :update_status, :id => 1, :story => { :status_id => 1 }, :project_id => @project.id
    assert_response :success
    
    story = assigns( :story )
    assert_not_nil story
  end
  
  #TODO: This could be far more robust
  def test_post_to_reorder_should_attempt_to_reorder
    Story.expects( :reorder ).with( [ 2, 1 ], :iteration_id => nil ).returns( true )

    post :reorder, :iteration_nil => [ 2, 1 ], :project_id=>@project.id
    assert_response :success
  end
end
