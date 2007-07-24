require File.dirname(__FILE__) + '/../../spec_helper'

describe "/dashboard/index.html.erb with projects" do
  
  before do
    @project1 = mock_model(Project)
    @project2 = mock_model(Project)
    
    @project1.stub!(:name).and_return("Project 1")
    @project1.stub!(:id).and_return(1)
    
    @project2.stub!(:name).and_return("Project 2")
    @project2.stub!(:id).and_return(2)
    
    @activity1 = mock_model(Activity)
    @activity2 = mock_model(Activity)    
    
        
    assigns[:projects] = [@project1, @project2]
    @project1_activities = [@activity1, @activity2]
    @project1.should_receive(:activities).and_return @project1_activities
    @project2.should_receive(:activities).and_return []

    template.expect_render :partial => "activities/list", :locals => { :project=>@project1, :activities=>@project1_activities }
    template.expect_render :partial => "activities/list", :locals => { :project=>@project2, :activities=>[] }

    render "/dashboard/index.html.erb"
  end

  it "creates a link for each project" do
    response.should have_tag(".project-title a[href='#{project_path(@project1.id)}']", @project1.name)
    response.should have_tag(".project-title a[href='#{project_path(@project2.id)}']", @project2.name)
  end

end