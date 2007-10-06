require File.dirname(__FILE__) + '/../../spec_helper'

describe "/iterations/_iteration.html.erb" do
  before do
    @stories = mock "stories"
    @iteration = mock "iteration"
    @iteration.stub!(:id).and_return(1)
    @iteration.stub!(:unique_id).and_return("unique_1")
    
    template.should_receive(:display_stories_list_for_iteration).with(@iteration).and_return(%|<p id="stories-list" />|)
    
    render :partial => "iterations/stories", :locals=> {:iteration=>@iteration, :stories => @stories}
  end
  
  it "render the stories list" do
    response.should have_tag("##{@iteration.unique_id}.story_list")
    response.should have_tag("#stories-list")    
  end
  
  it "renders a placeholder for a creating new stories" do
    response.should have_tag("##{@iteration.unique_id}_story_new")
  end
end
