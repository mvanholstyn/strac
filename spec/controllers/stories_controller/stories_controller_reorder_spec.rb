require File.dirname(__FILE__) + '/../../spec_helper'

describe StoriesController, '#reorder' do
  def xhr_put_reorder(attrs={})
    xhr :put, :reorder, {:project_id => @project.id, "iteration_nil" => @story_ids}.merge(attrs)
  end
  
  before do
    stub_login_for StoriesController
    @project = mock_model(Project)
    @story_ids = [ "3", "2", "", "1"]
    @renderer = mock("remote site renderer", :render_notice => nil, :render_error => nil)
    ProjectManager.stub!(:get_project_for_user).and_return(@project)
    RemoteSiteRenderer.stub!(:new).and_return(@renderer)
    Story.stub!(:reorder)
    controller.expect_render(:update).and_yield(@page)    
  end

  it "builds a remote site renderer" do
    RemoteSiteRenderer.should_receive(:new).with(:page=>@page).and_return(@renderer)
    xhr_put_reorder
  end

  it "reorders the story ids for the bucket" do
    expected_story_ids = @story_ids.select{ |id| !id.blank? }
    Story.should_receive(:reorder).with(expected_story_ids)
    xhr_put_reorder
  end
  
  describe "when the reordering of stories is successful" do
    before do
      Story.stub!(:reorder).and_return(true)
    end
    
    it "renders a notice message telling the user the priorities have been updated" do
      @renderer.should_receive(:render_notice).with("Priorities have been successfully updated.")
      xhr_put_reorder
    end
  end

  describe "when the reordering of stories is not successful" do
    before do
      Story.stub!(:reorder).and_return(false)
    end
    
    it "renders an error telling the user the priorities have not been updated" do
      @renderer.should_receive(:render_error).with("There was an error while updating priorities. If the problem persists, please contact technical support.")
      xhr_put_reorder
    end
  end
  
end
