require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories/show.html.erb" do
  include StoriesHelper
  
  before do
    @story = mock_model(Story)

    assigns[:story] = @story
  end

  it "should render attributes in <p>" do
    # render "/stories/show.html.erb"
  end
end

