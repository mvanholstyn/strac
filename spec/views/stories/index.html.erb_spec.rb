require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories/index.html.erb" do
  include StoriesHelper
  
  before do
    @iterations = mock "iterations array"
    assigns[:iterations] = @iterations
    template.expect_render(:partial => "iterations", :locals => {:iterations=>@iterations}).and_return(%|<p id="iterations-partial" />|)
    
    render "/stories/index.html.erb"
  end

  it "should render the iterations partial" do
    response.should have_tag("#iterations-partial")
  end
end

