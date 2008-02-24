require File.dirname(__FILE__) + '/../../spec_helper'

describe StoriesController, '#update_points' do
  def xhr_update_points
    xhr :put, :update_points, :project_id => @project.id, :id => @story.id, :story => { :points => @points }
  end
  
  before do
    stub_before_filters! :except => [:find_project]
    stub_login_for StoriesController
    @project = mock_model(Project)
    @project_manager = stub("project manager instance", :update_story_points => nil)
    @story = mock_model(Story, :project => @project, :summary => "FooBaz")
    @points = '11'
    @story_update = stub("story_update", :success => nil, :failure => nil)
    ProjectManager.stub!(:new).and_return(@project_manager)
    @project_manager.stub!(:update_story_points).and_yield(@story_update)
    @page = stub("page")
    controller.expect_render(:update).and_yield(@page)
    @remote_project_renderer = stub("remote project renderer", 
      :update_project_summary => nil, 
      :update_story_points => nil, 
      :render_notice => nil,
      :render_error => nil,
      :draw_current_iteration_velocity_marker => nil
    )
    RemoteProjectRenderer.stub!(:new).and_return(@remote_project_renderer)    
  end

  it "builds a ProjectManager for the current project and user" do
    ProjectManager.should_receive(:new).with(@project.id.to_s, @user).and_return(@project_manager)
    xhr_update_points
  end
  
  it "asks the newly built project manager to update the points on the requested story" do
    @project_manager.should_receive(:update_story_points).with(@story.id.to_s, @points.to_s)
    xhr_update_points
  end
  
  describe "when the update is successful" do
    before do
      @story_update.stub!(:success).and_yield(@story)
    end
    
    it "asks the story for its project" do
      @story.should_receive(:project).and_return(@project)
      xhr_update_points
    end
        
    it "builds a RemoteProjectRenderer for the project" do
      RemoteProjectRenderer.should_receive(:new).with(:page => @page, :project => @project).and_return(@remote_project_renderer)
      xhr_update_points
    end

    it "tells the renderer to render a notice telling the user the update was successful" do
      @remote_project_renderer.should_receive(:render_notice).with(%|"#{@story.summary} was successfully updated."|)
      xhr_update_points
    end
    
    it "tells the renderer to update the story points" do
      @remote_project_renderer.should_receive(:update_story_points).with(@story)
      xhr_update_points
    end
    
    it "tells the renderer to update the project's summary" do
      @remote_project_renderer.should_receive(:update_project_summary)
      xhr_update_points
    end
    
    it "tells the renderer to draw the current iteration velocity marker" do
      @remote_project_renderer.should_receive(:draw_current_iteration_velocity_marker)
      xhr_update_points
    end
  end

  describe "when the update fails" do
    before do
      @story_update.stub!(:failure).and_yield(@story)
    end

    it "asks the story for its project" do
      @story.should_receive(:project).and_return(@project)
      xhr_update_points
    end
        
    it "builds a RemoteProjectRenderer for the project" do
      RemoteProjectRenderer.should_receive(:new).with(:page => @page, :project => @project).and_return(@remote_project_renderer)
      xhr_update_points
    end
    
    it "tells the renderer to render an error telling the user the update was not successful" do
      @remote_project_renderer.should_receive(:render_error).with(%("#{@story.summary}" was not successfully updated.))
      xhr_update_points
    end
  end

end
