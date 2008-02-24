require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectManager, '.all_projects_for_user' do
  def all_projects_for_user
    ProjectManager.all_projects_for_user @user
  end
  
  before do
    @user = mock_model(User)
    @projects = stub("projects")
    ProjectPermission.stub!(:find_all_projects_for_user)
  end
  
  it "finds and returns all projects the passed in user has permissions on" do
    ProjectPermission.should_receive(:find_all_projects_for_user).with(@user).and_return(@projects)
    all_projects_for_user.should == @projects
  end
end

describe ProjectManager, '.get_project_for_user' do
  def get_project_for_user
    ProjectManager.get_project_for_user(@project.id, @user)
  end
  
  before do
    @user = mock_model(User)
    @project = mock_model(Project)
    ProjectPermission.stub!(:find_project_for_user).and_return(@project)
  end
  
  it "finds the requested project for the passed in user" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id, @user).and_return(@project)
    get_project_for_user
  end
  
  describe "when the requested project cannot be found for the user" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(nil)
    end
    
    it "raise an AccessDenied exception" do
      lambda{
        get_project_for_user
      }.should raise_error(AccessDenied)
    end
  end
  
  describe "when the requested project is found" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(@project)
    end
    
    it "returns the project" do
      get_project_for_user.should == @project
    end
  end
end

describe ProjectManager, ".update_project_for_user" do
  def update_project_for_user(&blk)
    ProjectManager.update_project_for_user(@project.id, @user, @project_attrs, @user_ids, &blk)
  end
  
  before do
    @project = mock_model(Project, :update_attributes => nil)
    @user = mock_model(User)
    @project_attrs = mock("project attributes")
    @user_ids = [1,2,3,55]
  end

  it "finds the requested project for the passed in user" do
    ProjectPermission.should_receive(:find_project_for_user).with(@project.id, @user).and_return(@project)
    update_project_for_user
  end
  
  describe "when the requested project cannot be found for the user" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(nil)
    end
    
    it "raise an AccessDenied exception" do
      lambda{
        update_project_for_user
      }.should raise_error(AccessDenied)
    end
  end

  describe "when the requested project is found" do
    before do
      ProjectPermission.stub!(:find_project_for_user).and_return(@project)
    end

    it "updates the project with the passed in attributes" do
      @project.should_receive(:update_attributes).with(@project_attrs)
      update_project_for_user
    end
    
    describe "when the project update fails" do
      before do
        @project.stub!(:update_attributes).and_return(false)
      end
      
      it "yields a Multiblock signifying failure which passes in the project" do
        failed = false
        update_project_for_user do |mb|
          mb.failure { |project| 
            project.should == @project
            failed = true
          }
        end
        failed.should be_true
      end
    end

    describe "when the project update succeeds" do
      before do
        @project.stub!(:update_attributes).and_return(true)
        @project.stub!(:update_members)
      end
      
      it "tells the project to update the members of the project" do
        @project.should_receive(:update_members).with(@user_ids)
        update_project_for_user
      end
      
      it "yields a Multiblock signifying success which passes in the project" do
        success = false
        update_project_for_user do |mb|
          mb.success { |project| 
            project.should == @project
            success = true
          }
        end
        success.should be_true
      end
    end
    
  end
end


describe ProjectManager, 'constructor' do
  before do
    @user = mock_model(User)
  end
  
  it "finds the project for the passed in project_id and user" do
    ProjectManager.should_receive(:get_project_for_user).with('11', @user)
    ProjectManager.new '11', @user
  end
end

describe ProjectManager, '#update_story_points' do
  def update_story_points(&blk)
    ProjectManager.new(@project.id, @user).update_story_points(@story.id, @points, &blk)
  end
  
  before do
    @user = mock_model(User)
    @story = mock_model(Story, :update_attribute => nil)
    @points = 1000
    @stories = stub("stories", :find => @story)
    @project = mock_model(Project, :stories => @stories)
    ProjectManager.stub!(:get_project_for_user).and_return(@project)
  end

  it "finds the story matching the passed in story_id" do
    @project.should_receive(:stories).and_return(@stories)
    @stories.should_receive(:find).with(@story.id).and_return(@story)
    update_story_points
  end
  
  describe "when the story is not be found" do
    before do
      @stories.stub!(:find).and_return(nil)
    end
    
    it "raises an ResourceNotFoundError" do
      lambda{ 
        update_story_points
      }.should raise_error(ResourceNotFoundError)
    end
  end
  
  describe "when the story is found" do
    before do
      @stories.stub!(:find).and_return(@story)
    end
    
    it "updates the story's points to the passed in points" do
      @story.should_receive(:update_attribute).with(:points, @points)
      update_story_points
    end
  
    describe "when the story update is successful" do
      before do
        @story.stub!(:update_attribute).and_return(true)
      end
    
      it "yields a Multiblock signifying success which passes in the story" do
        success = false
        update_story_points do |story_update|
          story_update.success { |story| 
            story.should == @story
            success = true
          }
        end
        success.should be_true
      end
    end
  
    describe "when the story update fails" do
      before do
        @story.stub!(:update_attribute).and_return(false)
      end
    
      it "yields a Multiblock signifying failure which passes in the story" do
        failed = false
        update_story_points do |story_update|
          story_update.failure { |story| 
            story.should == @story
            failed = true
          }
        end
        failed.should be_true
      end
    end
  end
end

