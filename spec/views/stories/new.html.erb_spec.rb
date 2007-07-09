require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories/new.html.erb" do
  include StoriesHelper
  
  before do
    @story = mock_model(Story)
    @story.stub!(:new_record?).and_return(true)
    assigns[:story] = @story
  end

  it "should render new form" do
    # render "/stories/new.html.erb"
    # 
    # response.should have_tag("form[action=?][method=post]", stories_path) do
    # end
  end
end


