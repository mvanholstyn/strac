require File.dirname(__FILE__) + '/../../spec_helper'

describe StoriesController, '#edit' do
  def get_edit(attrs={})
    get :edit, {:project_id => '1', :id => '2'}.merge(attrs)
  end
  
  before do
    stub_login_for StoriesController
    @project = stub("project")
    @stories = stub("stories", :find => nil)
    ProjectPermission.stub!(:find_project_for_user).and_return(@project)
    @project.stub!(:stories).and_return(@stories)
  end
  
  it "finds the requested story" do
    @project.should_receive(:stories).and_return(@stories)
    @stories.should_receive(:find).with('2', :include => :tags)
    get_edit
  end
  
  it "assigns @story" do
    story = stub("story")
    @stories.stub!(:find).and_return(story)
    get_edit
    assigns[:story].should == story
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
