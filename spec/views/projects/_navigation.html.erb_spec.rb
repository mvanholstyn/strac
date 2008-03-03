require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/_navigation.html.erb" do
  before(:each) do
    @project = mock_model(Project)

    render :partial => "projects/navigation", :locals => { :project => @project }
  end
  
  it "displays a link to the project's overview" do
    response.should have_tag("a[href=?]", project_path(@project))
  end
  
  it "displays a link to the project's workspace" do
    response.should have_tag("a[href=?]", workspace_project_path(@project))
  end
  
  it "displays a link to the project's iterations" do
    response.should have_tag("a[href=?]", iterations_path(@project))
  end
  
  it "displays a link to the project's stories" do
    response.should have_tag("a[href=?]", stories_path(@project))
  end
  
  it "displays a link to phases" do
    response.should have_tag("a[href=?]", project_phases_path(@project))
  end

  it "displays a link to invite people to this project" do
    response.should have_tag("a[href=?]", new_project_invitation_path(@project))
  end

end
