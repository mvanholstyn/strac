require File.dirname(__FILE__) + '/../../spec_helper'

describe "/comments/index.html.erb with comments" do

  def render_it
    render "/comments/index.html.erb"    
  end
  
  before do
    @story = stub(
      "Story",
      :summary => "Story Summary"
    ) 
    assigns[:story] = @story
    template.expect_render(:partial => "comments/comments", :locals => { :story => @story }).and_return(%|<p id="comments-partial" />|)
  end

  it "should render the comments/comments partial" do
    render_it
    response.should have_tag("#comments-partial")
  end
  
end


