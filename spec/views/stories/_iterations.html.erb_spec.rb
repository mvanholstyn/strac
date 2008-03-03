require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories/_iterations.html.erb" do

  def render_it
    render(
      :partial => "stories/iterations", 
      :locals => {
        :iterations => @iterations, 
        :iteration_list_ids => @iteration_list_ids } )
  end
  
  before do
    @project = mock_model(Project) ; @project.stub!(:id).and_return(5)
    @backlog = mock "backlog"
    
    @iterations = [ mock_model(Iteration), mock_model(Iteration) ]
    @iterations[0].stub!(:stories).and_return(mock("stories0"))
    @iterations[1].stub!(:stories).and_return(mock("stories1"))
    @backlog.stub!(:stories).and_return(mock("backlog stories"))

    @iterations.stub!(:backlog).and_return(@backlog)    
    @backlog.stub!(:unique_id).and_return("iteration_nil")
    @backlog.stub!(:project).and_return(@project)
    @iterations[0].stub!(:unique_id).and_return("iteration_1")
    @iterations[0].stub!(:project).and_return(@project)
    @iterations[1].stub!(:unique_id).and_return("iteration_2")
    @iterations[1].stub!(:project).and_return(@project)
    
    template.should_receive(:sortable_element).
      with(
        @backlog.unique_id, 
        :url => reorder_stories_path(@backlog.project),
        :method => :put,
        :tag => 'div',
        :handle => 'draggable',
        :dropOnEmpty => true,
        :containment => ["containment ids"]).
      and_return(%|<p id="sortable-elements-helper" />|)
        
    assigns[:project] = @project
    assigns[:iteration] = @iteration

    template.expect_render(:partial => 'iterations/list', :locals => { :iterations => @iterations }).and_return(%|<p id="iterations-list-partial1" />|)
    template.expect_render(:partial => "iterations/stories", :locals=>{:iteration=> @iterations.backlog, :stories => @iterations.backlog.stories}).and_return(%|<p id="iterations-stories-partial" />|)

    render_it
  end
  
  it "renders a remote link to create a new story" do
    response.should have_tag("a.create-story[onclick*=?]", new_story_path(@iterations.backlog.project.id))
  end
  
  it "renders the iterations/list" do
    response.should have_tag("#iterations-list-partial1")
  end

  it "renders each iteration as a sortable element" do
    response.should have_tag("#sortable-elements-helper")
  end
  
end
