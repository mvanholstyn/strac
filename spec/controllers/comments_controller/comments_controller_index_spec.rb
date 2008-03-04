require File.dirname(__FILE__) + '/../../spec_helper'

describe CommentsController, '#index' do
  it_requires_login :get, :index, :project_id => '1', :story_id => '2'
end

describe CommentsController, '#index' do
  def get_index
    get :index, :project_id => @project.id.to_s, :story_id => @story.id.to_s
  end
  
  before do
    stub_login_for CommentsController
    @project = mock_model(Project)
    @comments = stub("comments")
    @story = mock_model(Story, :comments => @comments)
    Story.stub!(:find).and_return(@story)
  end
  
  it "finds the story the requested comments belong to" do
    Story.should_receive(:find).with(@story.id.to_s).and_return(@story)
    get_index
  end
  
  it "asks the story for its comments" do
    @story.should_receive(:comments).and_return(@comments)
    get_index
  end
  
  it "assigns @comments" do
    get_index
    assigns[:comments].should == @comments
  end

  describe "with an html request" do
    it_renders_the_default_template :get, :index, :project_id => '1', :story_id => '2'
  end
  
  describe "with a xhr request" do
    it_renders_the_default_template :xhr, :get, :index, :project_id => '1', :story_id => '2'    
  end
end