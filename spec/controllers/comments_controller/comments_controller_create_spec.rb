require File.dirname(__FILE__) + '/../../spec_helper'

describe CommentsController, '#create' do
  it_requires_login :post, :create, :project_id => '1', :story_id => '2', :comment => @comment_params
end

describe CommentsController, '#create' do
  def post_create
    post :create, :project_id => @project.id.to_s, :story_id => @story.id.to_s, :comment => @comment_params
  end
  
  before do
    @user = stub_login_for CommentsController
    @project = mock_model(Project)
    @comment_params = {'a' => 'b'}
    @comment = mock_model(Comment, :commenter= => nil, :save => nil)
    @comments = stub("comments", :build => @comment)
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
    @comments.should_receive(:build).with(@comment_params).and_return(@comment)
    post_create
  end
  
  it "assigns the newly built comment" do
    post_create
    assigns[:comment].should == @comment
  end
  
  it "sets the comment's commenter to the current user" do
    @comment.should_receive(:commenter=).with(@user)
    post_create
  end
  
  it "saves the comment" do
    @comment.should_receive(:save)
    post_create
  end

  describe "when the comment saves successfully" do
    before do
      @comment.should_receive(:save).and_return(true)
    end

    describe "with a xhr request" do
      it_renders_the_default_template :xhr, :post, :create, :project_id => '1', :story_id => '2'    
    end    
  end
  
  describe "when the comment fails to save" do
    before do
      @comment.should_receive(:save).and_return(false)
    end

    describe "with a xhr request" do
      it "renders the new template" do
        post_create
        response.should render_template("new")
      end
    end
  end
  
end