require File.dirname(__FILE__) + '/../../spec_helper'

describe IterationsController, '#create' do
  def post_create
    post :create, :project_id => @project.id
  end
  
  before do
    @user = stub_login_for IterationsController
    @iteration = mock_model(Iteration, :name => nil)
    @project = mock_model(Project, :start_new_iteration! => @iteration)
    ProjectPermission.stub!(:find_project_for_user).and_return(@project)
  end

  it "finds and assigns the @project for the requested story" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id.to_s, @user).and_return(@project)
    post_create
    assigns[:project].should == @project
  end
  
  describe "when a project can't be found" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(nil)
    end
    
    it "redirects to access_denied" do
      post_create
      response.should redirect_to("/access_denied.html")
    end
  end
  
  it "tells the project to start a new iteration" do
    @project.should_receive(:start_new_iteration!).and_return(@iteration)
    post_create
  end
          
  it "sets the flash[:notice] message telling the user the iteration was successfully created" do
    @iteration.should_receive(:name).and_return("Iteration 8")
    post_create
    flash[:notice].should == %|Successfully started "Iteration 8".|
  end
  
  it "redirects to the project's workspace page" do
    post_create
    response.should redirect_to(workspace_project_path(@project))
  end
end