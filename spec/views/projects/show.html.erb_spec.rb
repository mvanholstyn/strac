require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/show.html.erb" do
  def render_it
    assigns[:project] = @project
    render "projects/show"
  end
  
  before do
    @project = mock_model(Project, :name => "Foo", :recent_activities => nil)
    template.stub_render(:partial => "activities/list", :locals => anything)
  end

  it "display's the project's name" do
    render_it
    response.should have_text("Foo".to_regexp)
  end
  
  it "displays a project chart image" do
    render_it
    response.should have_tag("img[src=?]", chart_project_path(@project))
  end
  
  it "renders the last week of activities" do
    @project.should_receive(:recent_activities).with(1.week).and_return("activities")
    template.expect_render(
      :partial => "activities/list",
      :locals => { :project => @project, :activities => "activities" }
    ).and_return(%|<p id="activities_list_partial" />|)
    render_it
    response.should have_tag('p#activities_list_partial')
  end
end
