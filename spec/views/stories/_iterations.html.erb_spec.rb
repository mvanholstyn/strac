require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories/_iterations.html.erb" do
  include StoriesHelper

  def render_it
    render(
      :partial => "stories/iterations", 
      :locals => {
        :iterations => @iterations, 
        :backlog => @backlog, 
        :iteration_list_ids => @iteration_list_ids } )
  end
  
  before do
    @project = mock_model(Project)
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
    
    @iterations.should_receive(:each_with_backlog).and_yield(@backlog)
    template.should_receive(:sortable_element).
      with(
        @backlog.unique_id, 
        :url => reorder_stories_path(@backlog.project),
        :method => :put,
        :tag => 'div',
        :handle => 'draggable',
        :dropOnEmpty => true,
        :containment => [@backlog.unique_id, @iterations[0].unique_id, @iterations[1].unique_id]).
      and_return(%|<p id="sortable-elements-helper" />|)
        
    assigns[:project] = @project
    assigns[:iteration] = @iteration
    
    template.expect_render(:partial => 'iterations/header', :locals => { :iteration => @iterations[0] }).and_return(%|<p id="iteration-header-partial0" />|)
    template.expect_render(:partial => 'iterations/header', :locals => { :iteration => @iterations[1] }).and_return(%|<p id="iteration-header-partial1" />|)
    template.expect_render(:partial => 'stories/list', :locals => { :stories => @iterations[0].stories }).and_return(%|<p id="stories-partial0" />|)
    template.expect_render(:partial => 'stories/list', :locals => { :stories => @iterations[1].stories }).and_return(%|<p id="stories-partial1" />|)
    template.expect_render(:partial => 'stories/list', :locals => { :stories => @backlog.stories }).and_return(%|<p id="backlog-stories-partial" />|)

    render_it
  end

  it "renders the iterations/header partial for each iteration" do
    response.should have_tag("#iteration-header-partial0")
    response.should have_tag("#iteration-header-partial1")
  end
  
  it "renders the stories/list partial for each iteration's stories" do
    response.should have_tag("#stories-partial0")
    response.should have_tag("#stories-partial1")
  end
  
  it "renders the stories/list partial for the backlog stories" do
    response.should have_tag("#backlog-stories-partial")    
  end
  
  it "renders each iteration as a sortable element" do
    response.should have_tag("#sortable-elements-helper")
  end
  
end
