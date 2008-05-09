require File.dirname(__FILE__) + '/../../spec_helper'

describe IterationsController, '#create' do
  def post_create
    post :create, :project_id => @project.id
  end
  
  before do
    @user = stub_login_for IterationsController
    @current_iteration = mock_model(Iteration, :start_date => nil, :update_attribute => nil)
    @new_current_iteration = mock_model(Iteration, :save! => nil, :name => nil)
    @iterations = mock("iterations", :current => @current_iteration, :find_or_build_current => @new_current_iteration)
    @project = mock_model(Project, :iterations => @iterations)
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
    it "gives the current iteration for the project an end date" do
      @project.should_receive(:iterations).and_return(@iterations)
      @iterations.should_receive(:current).and_return(@current_iteration)      
      @current_iteration.should_receive(:update_attribute).with(:end_date, Date.yesterday)
      post_create
    end
  end
    
  describe "when the current iteration started today" do
    before do
      @current_iteration.stub!(:start_date).and_return(Date.today)
    end
    
    it "sets the flash[:error] message telling the user they can't create another iteration" do
      post_create
      flash[:error].should == "You'll have to wait for two days to start another iteration."
    end
  end  

  describe "when the current iteration started yesterday" do
    before do
      @current_iteration.stub!(:start_date).and_return(Date.yesterday)
    end
    
    it "sets the flash[:error] message telling the user they can't create another iteration" do
      post_create
      flash[:error].should == "You'll have to wait for one day to start another iteration."
    end
  end  
    
  describe "when the current iteration did not start today" do
    it "creates a new current iteration for the project" do
      @project.should_receive(:iterations).and_return(@iterations)
      @iterations.should_receive(:find_or_build_current).and_return(@new_current_iteration)
      @new_current_iteration.should_receive(:save!)
      post_create
    end
    
    it "sets the flash[:notice] message telling the user the iteration was successfully created" do
      @new_current_iteration.should_receive(:name).and_return("Iteration 8")
      post_create
      flash[:notice].should == %|Successfully started "Iteration 8".|
    end
  end
  
  it "redirects to the project's workspace page" do
    post_create
    response.should redirect_to(workspace_project_path(@project))
  end
end