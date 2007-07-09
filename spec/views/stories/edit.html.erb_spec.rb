require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories/edit.html.erb" do
  include StoriesHelper
  
  before do
    @story = mock_model(Story)
    assigns[:story] = @story
  end

  it "should render edit form" do
    # render "/stories/edit.html.erb"
    # 
    # response.should have_tag("form[action=#{story_path(@story)}][method=post]") do
    # end
  end
end


