require File.dirname(__FILE__) + '/../../spec_helper'

describe CommentsController, '#new' do
  it_requires_login :get, :new, :project_id => '1', :story_id => '2'
end

describe CommentsController, '#new' do
  def post_create
    get :new, :project_id => @project.id.to_s, :story_id => @story.id.to_s, :id => @comment.id.to_s
  end
  
  before do
    @user = stub_login_for CommentsController
    @project = mock_model(Project)
    @comment = mock_model(Comment)
    @comments = stub("Comments", :build => @comment)
    @story = mock_model(Story, :comments => @comments)
    Story.stub!(:find).and_return(@story)
  end
  
  it "finds the story the requested comments belong to" do
    Story.should_receive(:find).with(@story.id.to_s).and_return(@story)
    post_create
  end
  
  it "asks the story for its comments" do
    @story.should_receive(:comments).and_return(@comments)
    post_create
  end
  
  it "builds a comment for the story" do
    @comments.should_receive(:build).with().and_return(@comment)
    post_create
  end
  
  it "assigns the newly built comment" do
    post_create
    assigns[:comment].should == @comment
  end
  
  describe "with a xhr request" do
    it_renders_the_default_template :xhr, :get, :new, :project_id => '1', :story_id => '2'    
  end    
    
end