require File.dirname(__FILE__) + '/../spec_helper'

describe RemoteProjectRenderer do
  def remote_project_renderer
    RemoteProjectRenderer.new(:page => @page, :project => @project)
  end
  
  before do
    @page_element = stub("remote page element", :replace => nil, :replace_html => nil)
    @page = stub("remote page", :[] => @page_element)
    @project = mock_model(Project)
  end

  describe '#draw_current_iteration_velocity_marker' do
    def draw_current_iteration_velocity_marker
      remote_project_renderer.draw_current_iteration_velocity_marker @average_velocity
    end
    
    before do
      @average_velocity = 20
    end
    
    it "tells the page to draw the current iteration velocity marker with the passed in average velocity" do
      @page.should_receive(:call).with("Strac.Iteration.drawCurrentIterationVelocityMarker", @average_velocity)
      draw_current_iteration_velocity_marker
    end
  end
  
  describe '#update_project_summary' do
    def update_project_summary 
      remote_project_renderer.update_project_summary
    end
    
    it "finds the project summary element" do
      @page.should_receive(:[]).with(:project_summary).and_return(@page_element)
      update_project_summary
    end
    
    it "replaces the project summary element with the projects/summary partial" do
      @page_element.should_receive(:replace).with(:partial => "projects/summary", :locals => { :project => @project })
      update_project_summary
    end
  end
  
  describe '#update_story_points' do
    def update_story_points
      remote_project_renderer.update_story_points(@story)
    end
    
    before do
      @story = mock_model(Story, :points => 10)
    end

    it "finds the element with the story's points" do
      @page.should_receive(:[]).with("story_#{@story.id}_points").and_return(@page_element)
      update_story_points
    end

    it "replaces the story's points element with the passed in story's points" do
      @page_element.should_receive(:replace_html).with(@story.points)
      update_story_points
    end
    
    describe "when the passed in story's points are blank" do
      before do
        @story.stub!(:points).and_return(nil)
      end
      
      it "replaces the story's points with the infinity symbol" do
        @page_element.should_receive(:replace_html).with("&infin;")
        update_story_points      
      end
    end
  end
end