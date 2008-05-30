require File.dirname(__FILE__) + '/../../spec_helper'

describe IterationsController, '#create' do
  def post_create
    post :create, :project_id => @project.id
  end
  
  before do
    @user = stub_login_for IterationsController
    @current_iteration = mock_model(Iteration, :started_at => nil, :update_attribute => nil)
    @new_current_iteration = mock_model(Iteration, 
      :build_snapshot => nil,
      :name => nil,
      :save! => nil )
    @iterations = mock("iterations", 
      :current => @current_iteration, 
      :find_or_build_current => @new_current_iteration)
    @project = mock_model(Project, 
      :total_points => 10,
      :completed_points => 11,
      :remaining_points => 12,
      :average_velocity => 13,
      :estimated_remaining_iterations => 14,
      :estimated_completion_date => Date.yesterday,
      :iterations => @iterations )
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
  
  describe "when the project has a current iteration" do
    it "sets the current iteration's for the project an end date" do
      now = Time.now
      Time.stub!(:now).and_return(now)
      @project.should_receive(:iterations).and_return(@iterations)
      @iterations.should_receive(:current).and_return(@current_iteration)
      @current_iteration.should_receive(:update_attribute).with(:ended_at, now - 1.second)
      post_create
    end
  end
        
  it "creates a new current iteration for the project" do
    @project.should_receive(:iterations).and_return(@iterations)
    @iterations.should_receive(:find_or_build_current).and_return(@new_current_iteration)
    @new_current_iteration.should_receive(:save!)
    post_create
  end
  
  it "creates a snapshot of the current project stats" do
    @new_current_iteration.should_receive(:build_snapshot).with(
      :total_points => @project.total_points,
      :completed_points => @project.completed_points,
      :remaining_points => @project.remaining_points,
      :average_velocity => @project.average_velocity,
      :estimated_remaining_iterations => @project.estimated_remaining_iterations,
      :estimated_completion_date => @project.estimated_completion_date)
    post_create
  end
  
  it "sets the flash[:notice] message telling the user the iteration was successfully created" do
    @new_current_iteration.should_receive(:name).and_return("Iteration 8")
    post_create
    flash[:notice].should == %|Successfully started "Iteration 8".|
  end
  
  it "redirects to the project's workspace page" do
    post_create
    response.should redirect_to(workspace_project_path(@project))
  end
end