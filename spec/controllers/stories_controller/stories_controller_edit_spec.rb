require File.dirname(__FILE__) + '/../../spec_helper'

describe StoriesController, '#edit' do
  def get_edit(attrs={})
    get :edit, {:project_id => '1', :id => '2'}.merge(attrs)
  end
  
  before do
    stub_login_for StoriesController
    @stories = stub("stories", :find => nil)
    @project = stub("project", :stories => @stories)
    ProjectManager.stub!(:get_project_for_user).and_return(@project)
    StoryPresenter.stub!(:new)
  end
  
  it "finds the requested story" do
    @project.should_receive(:stories).and_return(@stories)
    @stories.should_receive(:find).with('2', :include => :tags)
    get_edit
  end
  
  it "assigns @story" do
    story = stub("story")
    story_presenter = stub("story presenter")
    @stories.stub!(:find).and_return(story)
    StoryPresenter.should_receive(:new).with(:story => story).and_return(story_presenter)
    get_edit
    assigns[:story].should == story_presenter
  end
  
  describe StoriesController, 'html request' do
    it "renders the 'edit' template" do
      get_edit
      response.should render_template('edit')
    end
  end
  
  describe StoriesController, 'xhr request' do
    it "renders the 'edit.js.rjs' template" do
      xhr :get, :edit, :project_id => '1', :id => '2'
      response.should render_template('stories/edit')
    end
  end
end
