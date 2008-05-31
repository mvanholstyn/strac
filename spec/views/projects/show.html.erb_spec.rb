require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/show.html.erb" do
  def render_it
    assigns[:project] = @project
    render "projects/show"
  end
  
  before do
    @project = mock_model(Project, 
      :display_chart? => false,
      :name => "Foo", 
      :recent_activities => nil)
    template.stub_render(:partial => "activities/list", :locals => anything)
  end

  it "display's the project's name" do
    render_it
    response.should have_text("Foo".to_regexp)
  end
  
  describe "when the project chart should be displayed" do
    before do 
      @project.stub!(:display_chart?).and_return(true)
    end
  
    it "displays a project chart image" do
      render_it
      response.should have_tag("img[src=?]", chart_project_path(@project))
    end
  end
  
  describe "when the project chart should not be displayed" do
    before do 
      @project.stub!(:display_chart?).and_return(false)
    end

    it "does not display a project chart image" do
      render_it
      response.should_not have_tag("img[src=?]", chart_project_path(@project))
    end    
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
