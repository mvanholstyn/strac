require File.dirname(__FILE__) + '/../../spec_helper'

describe ProjectsController, '#workspace' do
  def get_workspace
    get :workspace, :id => @project.id
  end
  
  before do
    @user = mock_model(User)
    @stories = stub("stories")
    @project = mock_model(Project, :incomplete_stories => @stories)
    ProjectManager.stub!(:get_project_for_user).and_return(@project)
    login_as @user
  end

  it "asks the ProjectManager to find the requested project for the current user" do
    ProjectManager.should_receive(:get_project_for_user).with(@project.id.to_s, @user).and_return(@project)
    get_workspace
  end
  
  describe "a user with proper privileges" do
    before do
      ProjectManager.stub!(:get_project_for_user).and_return(@project)      
    end
    
    it "assigns the found project" do
      get_workspace
      assigns[:project].should == @project
    end
    
    it "asks the project for its incomplete stories" do
      @project.should_receive(:incomplete_stories).and_return(@stories)
      get_workspace
    end
    
    it "assigns the incomplete stories" do
      get_workspace
      assigns[:stories].should == @stories
    end

    it "renders workspace template" do
      get_workspace
      response.should be_success
      response.should render_template('workspace')
    end
  end
  
  describe "a user without proper privileges" do
    before do
      ProjectManager.stub!(:get_project_for_user).and_raise(AccessDenied)
    end
    
    it "redirects to the 401 access denied page" do
      get_workspace
      response.should redirect_to("/access_denied.html")
    end
  end
    
end

__END__
  def current
    @iteration = @project.iterations.find_or_build_current
    @stories = @project.stories.find(:all, :conditions => { :bucket_id => nil }, :order => :position)
  end
