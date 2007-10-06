require File.dirname(__FILE__) + '/../../spec_helper'

describe "/iterations/_iteration.html.erb" do
  before do
    @project = mock "project"
    @iteration = mock "iteration"
    @stories = mock "stories"

    @iteration.stub!(:id).and_return(1)
    @iteration.stub!(:unique_id).and_return("unique_1")
    @iteration.stub!(:stories).and_return(@stories)
    @iteration.stub!(:project).and_return(@project)

    @project.stub!(:id).and_return(2)
    
    template.expect_render(:partial => 'iterations/header', :locals => { :iteration => @iteration }).and_return(%|<p id="iteration-header-partial" />|)
    template.expect_render(:partial => 'iterations/stories', :locals => { :iteration => @iteration, :stories => @iteration.stories }).and_return(%|<p id="iteration-stories-partial" />|)
    
    render :partial => "iterations/iteration", :locals=> {:iteration=>@iteration}
  end

  it "renders a remote link to create a new story" do
    response.should have_tag("a.create-story[onclick*=?]", new_story_path(@project.id))
  end
  
  it "renders the iterations/header" do
    response.should have_tag("#iteration-header-partial")
  end
  
  it "renders the iterations/stories" do
    response.should have_tag("#iteration-stories-partial")
  end
end