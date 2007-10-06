require File.dirname(__FILE__) + '/../spec_helper'

describe StoriesController, "user with privileges requesting #index " do
  def get_index
    get :index, { :project_id=>'1' }, {:current_user_id=>2}    
  end

  before do
    @user = mock_model(User)
    @project = mock_model(Project)
    @iterations = mock "iterations"

    StoriesController.login_model.stub!(:find).and_return(@user)
    @user.stub!(:has_privilege?).and_return(true)
    
    @project.stub!(:iterations_ordered_by_start_date)
    @project.stub!(:backlog_iteration)
    IterationsPresenter.stub!(:new)

    Project.stub!(:find).and_return(@project)
  end

  it "returns successful" do
    get_index
    response.should be_success
  end
  
  it "renders the index.html.erb template" do
    get_index
    response.should render_template("index")
  end
  
  it "assigns @iterations to a IterationsPresenter" do
    @iterations_presenter = mock "iterations presenter"
    @backlog_iteration = mock "backlog iteration"
    @project.should_receive(:iterations_ordered_by_start_date).and_return(@iterations)
    @project.should_receive(:backlog_iteration).and_return(@backlog_iteration)
    IterationsPresenter.should_receive(:new).with(
      :iterations => @iterations, 
      :backlog => @backlog_iteration,
      :project => @project).and_return(@iterations_presenter)
    get_index

    assigns[:iterations].should == @iterations_presenter
  end
    
end
