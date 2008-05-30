require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/workspace.html.erb" do
  def render_it
    assigns[:project] = @project
    assigns[:stories] = @stories
    render "projects/workspace"
  end
  
  before do
    @project = mock_model(Project)
    @stories = [mock_model(Story), mock_model(Story)]
    template.stub!(:current_iteration_name).and_return("")
    template.stub_render(:partial  => 'stories/list', :locals => { :stories => @stories })
  end

  it "renders a link to create a story for the project" do
    render_it
    response.should have_remote_link(:onclick => new_story_path(@project))
  end
  
  it "renders the stories/list partial" do
    template.expect_render(:partial  => 'stories/list', :locals => { :stories => @stories }).and_return(%|<p id="stories-list-partial" />|)
    render_it
    response.should have_tag('p#stories-list-partial')
  end

  it "creates a sortable element for the backlog" do
    during_render do
      template.should receive_and_render(:sortable_element).with(
        "iteration_nil",
         :url => reorder_stories_path(@project), 
         :method => :put,
         :tag => 'div', 
         :handle => 'draggable', 
         :dropOnEmpty => true, 
         :onChange =>  "Strac.Iteration.drawWorkspaceVelocityMarkers"
      )
    end
  end

  it "renders a link to create an iteration" do
    render_it
    response.should have_tag('a[href=?][onclick *= post]', project_iterations_path(@project))
  end
end
