require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/_summary.html.erb" do
  def render_it
    render :partial => "projects/summary", :locals => { :project => @project }
  end
  
  before(:each) do
    @project = mock_model(Project, 
      :total_points => 0, 
      :completed_points => 0, 
      :remaining_points => 0,
      :iterations => [], 
      :average_velocity => 0, 
      :estimated_remaining_iterations => 0,
      :estimated_completion_date => nil)
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
    @project.should_receive(:iterations).and_return(iterations)
    render_it
    response.should have_tag('.project_summary .iterations', iterations.size.to_s)
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
    @project.should_receive(:estimated_completion_date).and_return("today")
    render_it
    response.should have_tag('.project_summary .estimated_completion_date', "today")  
  end
end
