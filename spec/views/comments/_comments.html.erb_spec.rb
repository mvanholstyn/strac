require File.dirname(__FILE__) + '/../../spec_helper'

describe "/comments/_comments.html.erb with comments" do

  def render_it
    render :partial => "/comments/comments.html.erb", :locals => { :story => @story } 
  end
  
  before do
    @comments = stub("Comments", :size => 0)
    @story = stub(
      "Story",
      :id => 1,
      :comments => @comments
    )
    template.stub_render(
      :partial => "comments/list", 
      :locals => { :comments => @comments }
      )
    template.stub_render(
      :partial => "comments/new", 
      :locals => { :story => @story }
      )
  end

  it "renders the comments/list partial" do
    template.expect_render(
      :partial => "comments/list", 
      :locals => { :comments => @comments }
      ).and_return(%|<p id="comments-list-partial" />|)
    render_it
    response.should have_tag("#comments-list-partial")
  end

  it "renders the comments/new partial" do
    template.expect_render(
      :partial => "comments/new", 
      :locals => { :story => @story }
    ).and_return(%|<p id="comments-new-partial" />|)
    render_it
    response.should have_tag("#comments-new-partial")
  end

  
  it "has a container for the new comment form" do
    render_it
    response.should have_tag("#story_#{@story.id}_new_comment")
  end

  it "has a container for the comments list" do
    render_it
    response.should have_tag("#story_#{@story.id}_comments_list")
  end

end

