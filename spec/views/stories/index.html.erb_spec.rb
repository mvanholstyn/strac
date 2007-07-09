require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories/index.html.erb" do
  include StoriesHelper
  
  before do
    story_98 = mock_model(Story)
    story_99 = mock_model(Story)
 
    iterations_proxy = stub("iterations", :find => [])
    stories_proxy = stub("stories", :find_backlog => [])
    
    project_98 = mock_model(Project)
    project_98.should_receive(:iterations).twice.and_return(iterations_proxy)
    project_98.should_receive(:stories).and_return(stories_proxy)

    assigns[:stories] = [story_98, story_99]
    assigns[:project] = project_98
  end

  it "should render list of stories" do
    render "/stories/index.html.erb"
  end
end

