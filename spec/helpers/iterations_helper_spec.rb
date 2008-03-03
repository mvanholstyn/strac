require File.dirname(__FILE__) + '/../spec_helper'

describe IterationsHelper, "#display_stories_list_for_iteration given an iteration that is be shown" do  
  it "returns the rendered stories/list partial" do
    @iteration = mock "iteration"
    @stories = mock "stories"
    
    @iteration.should_receive(:stories).and_return(@stories)
    self.should_receive(:render).with(
      :partial => 'stories/list', 
      :locals => { :stories => @stories }
    ).and_return("RENDERED LIST")

    display_stories_list_for_iteration(@iteration).should == "RENDERED LIST"
  end
end

