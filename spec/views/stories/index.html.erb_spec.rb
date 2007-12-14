require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories/index.html.erb" do
  include StoriesHelper

  def render_it
    render "/stories/index.html.erb"
  end
  
  before do
    @iterations = mock "iterations presenter"
    @stories_presenter = stub("stories presenter", :iterations_presenter => @iterations)
    assigns[:stories_presenter] = @stories_presenter
    template.expect_render(:partial => "stories/iterations", :locals => {:iterations=>@iterations}).and_return(%|<p id="iterations-partial" />|)
  end

  it "should render the iterations partial" do
    render_it
    response.should have_tag("#iterations-partial")
  end
end

