require File.dirname(__FILE__) + '/../spec_helper'

describe Project, "#new with no attributes" do
  before do
    @project = Project.new
  end

  it "should not be valid" do
    @project.should_not be_valid
  end

  it "can have many invitations" do
    assert_association Project, :has_many, :invitations, Invitation
  end
end

describe Project, "#new with name attribute" do
  it "should be valid" do
    @project = Project.new :name => "foo"
    @project.should be_valid
  end
  
  it "should not be valid with an empty string for name" do
    @project = Project.new :name => ""
    @project.should_not be_valid    
  end
end

describe Project, "#total_points" do
  before do
    Story.delete_all
    @project = Generate.project "foo"
    @stories = [
      Generate.story("story 1", :project => @project, :points => 1),
      Generate.story("story 2", :project => @project, :points => 2),
      Generate.story("story 3", :project => @project, :points => 4) ]
  end
  
  it "returns the sum of points for stories that belong to this project" do
    @project.total_points.should == @stories.map(&:points).sum
  end

  it "includes points for stories that are defined" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.defined
    @project.total_points.should == @stories.map(&:points).sum + story.points
  end

  it "includes points for stories that are in progress" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.in_progress
    @project.total_points.should == @stories.map(&:points).sum + story.points
  end

  it "includes points for stories that are complete" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.complete
    @project.total_points.should == @stories.map(&:points).sum + story.points
  end

  it "includes points for stories that are blocked" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.blocked
    @project.total_points.should == @stories.map(&:points).sum + story.points
  end
  
  it "ignores points for stories that are rejected" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.rejected
    @project.total_points.should == @stories.map(&:points).sum
  end
  

  describe "with stories that belong to an iteration" do
    it "includes the points that belong to stories attached to an iteration" do
      iteration = Generate.iteration "iteration1", :project => @project
      story = Generate.story "story that belongs to iteration", :project => @project, :bucket => iteration, :points => 10
      @project.total_points.should == @stories.map(&:points).sum + story.points
    end
  end
  
  describe "with stories that belong to a phase" do
    it "does not include points that belong to stories attached to a phase" do
      phase = Generate.phase "phase1", :project => @project
      story = Generate.story "story that belongs to phase", :project => @project, :bucket => phase, :points => 10
      @project.total_points.should == @stories.map(&:points).sum
    end
  end
end

describe Project, "#completed_points" do
  before do
    Story.delete_all
    @project = Generate.project "foo"
    @completed_stories = [
      Generate.story("story 1", :project => @project, :points => 1, :status => Status.complete),
      Generate.story("story 2", :project => @project, :points => 2, :status => Status.complete),
      Generate.story("story 3", :project => @project, :points => 4, :status => Status.complete) ]
    @not_completed_stories = [
      Generate.story("story a", :project => @project, :points => 1) ]
  end
  
  it "returns the sum of points for completed stories that belong to this project" do
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  it "ignores points for stories that are defined" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.defined
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  it "ignores points for stories that are in_progress" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.in_progress
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  it "ignores points for stories that are rejected" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.rejected
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  it "ignores points for stories that are blocked" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.blocked
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  describe "with stories that belong to an iteration" do
    it "includes the points that belong to completed stories attached to an iteration" do
      iteration = Generate.iteration "iteration1", :project => @project
      story = Generate.story "story that belongs to iteration", :project => @project, :bucket => iteration, :points => 10, :status => Status.complete
      sum = @completed_stories.map(&:points).sum + story.points
      @project.completed_points.should == sum
    end
    
    it "ignores points that belong to incomplete stories attached to an iteration" do
      iteration = Generate.iteration "iteration1", :project => @project
      story = Generate.story "story that belongs to iteration", :project => @project, :bucket => iteration, :points => 10
      @project.completed_points.should == @completed_stories.map(&:points).sum
    end
  end
  
  describe "with stories that belong to a phase" do
    it "ignores points that belong to stories attached to a phase" do
      phase = Generate.phase "phase1", :project => @project
      story = Generate.story "story that belongs to phase", :project => @project, :bucket => phase, :points => 10
      story = Generate.story "story2 that belongs to phase", :project => @project, :bucket => phase, :points => 10, :status => Status.complete
      @project.completed_points.should == @completed_stories.map(&:points).sum
    end
  end
end

describe Project, "#remaining_points" do
  before do
    Story.delete_all
    @project = Generate.project "foo"
    @complete_stories = [
      Generate.story("story 1", :project => @project, :points => 1, :status => Status.complete),
      Generate.story("story 2", :project => @project, :points => 2, :status => Status.complete),
      Generate.story("story 3", :project => @project, :points => 4, :status => Status.complete) ]
    @remaining_stories = [
      Generate.story("story 1", :project => @project, :points => 1),
      Generate.story("story 2", :project => @project, :points => 2) ]
  end
  
  it "returns the sum of points for incomplete stories belong to this project" do
    @project.remaining_points.should == @remaining_stories.map(&:points).sum
  end
  
  it "includes points for stories that are defined" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.defined
    @project.remaining_points.should == @remaining_stories.map(&:points).sum + story.points
  end

  it "includes points for stories that are in progress" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.in_progress
    @project.remaining_points.should == @remaining_stories.map(&:points).sum + story.points
  end

  it "ignores points for stories that are completed" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.complete
    @project.remaining_points.should == @remaining_stories.map(&:points).sum
  end

  it "includes points for stories that are blocked" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.blocked
    @project.remaining_points.should == @remaining_stories.map(&:points).sum + story.points
  end
  
  it "ignores points for stories that are rejected" do
    story = Generate.story "story", :project => @project, :points => 10, :status => Status.rejected
    @project.remaining_points.should == @remaining_stories.map(&:points).sum
  end
  
  describe "with stories that belong to an iteration" do
    it "includes points that belong to incomplete stories attached to an iteration" do
      iteration = Generate.iteration "iteration1", :project => @project
      story = Generate.story "story that belongs to iteration", :project => @project, :bucket => iteration, :points => 10
      @project.remaining_points.should == @remaining_stories.map(&:points).sum + story.points
    end
  end
  
  describe "with stories that belong to a phase" do
    it "ignores points that belong to stories attached to a phase" do
      phase = Generate.phase "phase1", :project => @project
      story = Generate.story "story that belongs to phase", :project => @project, :bucket => phase, :points => 10
      @project.remaining_points.should == @remaining_stories.map(&:points).sum
    end
  end
end


describe Project, "recent_activities" do
  before do
    @project = Project.create :name=>"Project w/Activities"
    
    @activity1 = Activity.create(:project_id=>@project.id, :actor_id=>1, :action=>"creating", :affected_id=>1, :affected_type=>"story1")
    @activity1.update_attribute 'created_at', Date.today
    
    @activity2 = Activity.create(:project_id=>@project.id, :actor_id=>1, :action=>"editing", :affected_id=>2, :affected_type=>"story2")
    @activity2.update_attribute 'created_at', Date.today - 1

    @activity3 = Activity.create(:project_id=>@project.id, :actor_id=>1, :action=>"editing", :affected_id=>3, :affected_type=>"story3")
    @activity3.update_attribute 'created_at', Date.today - 2

    @activity4 = Activity.create(:project_id=>@project.id, :actor_id=>1, :action=>"editing", :affected_id=>4, :affected_type=>"story4")
    @activity4.update_attribute 'created_at', Date.today - 7

    @activity5 = Activity.create(:project_id=>@project.id, :actor_id=>1, :action=>"editing", :affected_id=>5, :affected_type=>"story5")
    @activity5.update_attribute 'created_at', Date.today - 8
  end
  
  
  it "returns only project activities from within the past day when given no arguments" do
    @activities = @project.recent_activities
    @activities.should == [@activity1, @activity2]
  end

  it "returns only project activities from within the past 2 days when given an argument of 2.days" do
    @activities = @project.recent_activities(2.days)
    @activities.should == [@activity1, @activity2, @activity3]
  end

  it "returns only project activities from within the past week when given an argument of 1.week" do
    @activities = @project.recent_activities(1.week)
    @activities.should == [@activity1, @activity2, @activity3, @activity4]
  end
end

describe Project, "iterations_ordered_by_start_date" do
  before do
    @project = Generate.project "ProjectA"
    @iteration1 = (Generate.iteration "Iteration5", :project => @project, :start_date => Date.today - 3.weeks)
    @iteration3 = (Generate.iteration "Iteration5", :project => @project, :start_date => Date.today - 1.week)
    @iteration2 = (Generate.iteration "Iteration5", :project => @project, :start_date => Date.today - 2.weeks)
    @project.iterations = [ @iteration1, @iteration3, @iteration2 ]
    @project.save!
  end
  
  it "finds all iterations ordered by their start date" do
    @project.iterations_ordered_by_start_date.should == [ @iteration1, @iteration2, @iteration3 ]
  end
end

describe Project, "#backlog_stories" do
  before do
    @project = Generate.project "ProjectA"
    @iteration = Generate.iteration "Iteration1", :project => @project
    
    @story1 = Generate.story "story1", :project => @project
    @story2 = Generate.story "story2", :project => @project
    @story3 = Generate.story "story3", :project => @project ; @story3.move_higher #acts_as_list
    @story4 = Generate.story "story4", :project => @project, :bucket => @iteration
  end
  
  it "finds all of the project not assigned to an iteration ordered by position" do
    @project.backlog_stories.should == [ @story1, @story3, @story2 ]
  end
end

describe Project, "#backlog_iteration" do
  setup do
    @project = Generate.project "ProjectA"
    @backlog = @project.backlog_iteration
  end
  
  it "returns a new Iteration" do
    @backlog.new_record?.should be_true
  end
  
  it "returns an Iteration named 'Backlog'" do
    @backlog.name.should == "Backlog"
  end
end
