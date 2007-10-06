require File.dirname(__FILE__) + '/../spec_helper'

describe IterationsHelper, "#display_stories_list_for_iteration given an iteration that is not to be shown" do
  it "returns a remote link to the stories_iteration_path" do
    @iteration = mock "iteration"
    @project = mock "project"

    @iteration.should_receive(:show?).and_return(false)
    @iteration.should_receive(:project).and_return(@project)
    @project.stub!(:id).and_return(1)
    @iteration.stub!(:id).and_return(2)
    @iteration.stub!(:name).and_return("Iteration 1")
    self.should_receive(:link_to_remote).with(
      "show iteration", 
      :url => stories_iteration_path(@project.id, @iteration.id),
      :method => :get, 
      :loading => "Element.update('notice', 'Loading #{@iteration.name}...') ; Element.show('notice')", 
      :success => "Element.hide('notice')"
    ).and_return("REMOTE LINK")

    display_stories_list_for_iteration(@iteration).should == "REMOTE LINK"
  end
end

describe IterationsHelper, "#display_stories_list_for_iteration given an iteration that is be shown" do  
  it "returns the rendered stories/list partial" do
    @iteration = mock "iteration"
    @stories = mock "stories"
    
    @iteration.should_receive(:show?).and_return(true)
    @iteration.should_receive(:stories).and_return(@stories)
    self.should_receive(:render).with(
      :partial => 'stories/list', 
      :locals => { :stories => @stories }
    ).and_return("RENDERED LIST")

    display_stories_list_for_iteration(@iteration).should == "RENDERED LIST"
  end
end

