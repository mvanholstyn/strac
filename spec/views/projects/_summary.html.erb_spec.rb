require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/_summary.html.erb" do
  def render_it
    render :partial => "projects/summary", :locals => { :project => @project }
  end
  
  before do
    @current_iteration = mock_model(Iteration, :name => "Iteration & 1099")
    @project = mock_model(Project, 
      :iterations => mock("iterations", :current => @current_iteration),
      :total_points => 0, 
      :completed_points => 0, 
      :remaining_points => 0,
      :completed_iterations => [], 
      :average_velocity => 0, 
      :estimated_remaining_iterations => 0,
      :estimated_completion_date => Date.today)
  end
  
  describe "when a current iteration is supplied" do
    it "displays the current iteration name" do
      render_it
      response.should have_tag(".current_iteration", h(@current_iteration.name).to_regexp)
    end
  end
  
  describe "when a current iteration is not supplied" do
    before do
      @project.iterations.stub!(:current).and_return(nil)
    end
    
    it "still renders" do
      render_it
      response.should have_tag(".current_iteration")
    end
  end
  
  it "renders the project's total points" do
    @project.should_receive(:total_points).and_return("99")
    render_it
    response.should have_tag('.project_summary .total_points', "99")
  end
  
  it "renders the project's completed points" do
    @project.should_receive(:completed_points).and_return("98")
    render_it
    response.should have_tag('.project_summary .completed_points', "98")
  end
  
  it "renders the project's remaining points" do
    @project.should_receive(:remaining_points).and_return("97")
    render_it
    response.should have_tag('.project_summary .remaining_points', "97")
  end
  
  it "renders the project's completed iteration count" do
    iterations = [1,2,3,4]
    @project.should_receive(:completed_iterations).and_return(iterations)
    render_it
    response.should have_tag('.project_summary .completed_iterations', iterations.size.to_s)
  end
  
  it "renders the project's average velocity" do
    @project.should_receive(:average_velocity).and_return(101)
    render_it
    response.should have_tag('.project_summary .average_velocity', "101")
  end
  
  it "renders the project's estimated remaining iterations" do
    @project.should_receive(:estimated_remaining_iterations).and_return(91)
    render_it
    response.should have_tag('.project_summary .estimated_remaining_iterations', "91")
  end
  
  it "renders the project's estimated completion date" do
    today = Date.today
    @project.should_receive(:estimated_completion_date).and_return(today)
    render_it
    response.should have_tag('.project_summary .estimated_completion_date', today.strftime("%m-%d-%Y"))  
  end
end
