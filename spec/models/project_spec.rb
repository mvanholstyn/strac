require File.dirname(__FILE__) + '/../spec_helper'

describe Project, "#new with no attributes" do
  before do
    @project = Project.new
  end

  it "should not be valid" do
    @project.should_not be_valid
  end

  it "has many invitations" do
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

describe Project, '#story_tags' do
  before do
    @project = Generate.project :name => "foo"
    @stories = [
      Generate.story(:summary => "story 1", :project => @project),
      Generate.story(:summary => "story 2", :project => @project) ]
    @stories.first.tag_list = "foo, baz"
    @stories.last.tag_list = "foo, baz, bar"
    @stories.each{ |s| s.save! }
  end
  
  it "returns the unique tags that belong to the stories on this project" do
    @project.story_tags.should == (@stories.first.tags + @stories.last.tags).uniq
  end
end

describe Project, '#tagless_stories' do
  before do
    @project = Generate.project :name => "foo"
    @stories = [
      Generate.story(:summary => "story1", :project => @project),
      Generate.story(:summary => "story2", :project => @project),
      Generate.story(:summary => "story3", :project => @project) ]
    @stories[0].tag_list = ""
    @stories[1].tag_list = "foo, baz, bar"    
    @stories[2].tag_list = ""
    @stories.each{ |s| s.save! }
  end
  
  it "returns stories which are not tagged" do
    @project.tagless_stories.should == [@stories[0], @stories[2]]
  end
  
  it "doesn't include stories from other projects" do
    @project2 = Generate.project :name => "baz"
    @story2 = Generate.story :summary => "another project's story", :project => @project2
    @project.tagless_stories.should_not include(@story2)
  end
end

describe Project, "#total_points" do
  before do
    Story.delete_all
    @project = Generate.project "foo"
    @stories = [
      Generate.story(:summary => "story 1", :project => @project, :points => 1),
      Generate.story(:summary => "story 2", :project => @project, :points => 2),
      Generate.story(:summary => "story 3", :project => @project, :points => 4) ]
  end
  
  it "returns the sum of points for stories that belong to this project" do
    @project.total_points.should == @stories.map(&:points).sum
  end

  it "includes points for stories that are defined" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.defined
    @project.total_points.should == @stories.map(&:points).sum + story.points
  end

  it "includes points for stories that are in progress" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.in_progress
    @project.total_points.should == @stories.map(&:points).sum + story.points
  end

  it "includes points for stories that are complete" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.complete
    @project.total_points.should == @stories.map(&:points).sum + story.points
  end

  it "includes points for stories that are blocked" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.blocked
    @project.total_points.should == @stories.map(&:points).sum + story.points
  end
  
  it "ignores points for stories that are rejected" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.rejected
    @project.total_points.should == @stories.map(&:points).sum
  end
  

  describe "with stories that belong to an iteration" do
    it "includes the points that belong to stories attached to an iteration" do
      iteration = Generate.iteration "iteration1", :project => @project
      story = Generate.story :summary => "story that belongs to iteration", :project => @project, :bucket => iteration, :points => 10
      @project.total_points.should == @stories.map(&:points).sum + story.points
    end
  end
  
  describe "with stories that belong to a phase" do
    it "does not include points that belong to stories attached to a phase" do
      phase = Generate.phase "phase1", :project => @project
      story = Generate.story :summary => "story that belongs to phase", :project => @project, :bucket => phase, :points => 10
      @project.total_points.should == @stories.map(&:points).sum
    end
  end
end

describe Project, '#average_velocity' do
  def average_velocity
    velocity = @stories.sum{|s| s.points.blank? ? 0 : s.points}.to_f / @completed_iterations.size.to_f
    @project.average_velocity.should == velocity
  end

  before do
    @project = Generate.project "project foo"
    @completed_iterations = [
      Generate.iteration("completed 1", :start_date => 1.week.ago, :end_date => Time.now.yesterday, :project => @project),
      Generate.iteration("completed 2", :start_date => 3.weeks.ago, :end_date => 2.weeks.ago, :project => @project) 
    ]
    @stories = [
      Generate.story(:summary => "A", :bucket => @completed_iterations.first, :points => 100, :project => @project, :status => Status.complete),
      Generate.story(:summary => "B", :bucket => @completed_iterations.last, :points => 50, :project => @project, :status => Status.complete) 
    ]
  end
  
  it "computes the average number of completed points from completed iterations" do
    average_velocity
  end
  
  it "ignores points associated with incomplete stories" do
    Generate.story(:summary => "incomplete 1", :bucket => @completed_iterations.first, :points => 100, :project => @project)
    Generate.story(:summary => "incomplete 1", :bucket => @completed_iterations.first, :points => 100, :project => @project, :status => Status.defined)
    Generate.story(:summary => "incomplete 1", :bucket => @completed_iterations.first, :points => 100, :project => @project, :status => Status.blocked)
    Generate.story(:summary => "incomplete 1", :bucket => @completed_iterations.first, :points => 100, :project => @project, :status => Status.rejected)
    Generate.story(:summary => "incomplete 1", :bucket => @completed_iterations.first, :points => 100, :project => @project, :status => Status.in_progress)
    average_velocity
  end
  
  it "ignores points associated with phases" do
    phase = Generate.phase "phase", :project => @project
    Generate.story :summary => "story for phase", :bucket => @phase, :project => @project, :points => 200
    average_velocity
  end
  
  it "ignores points associated with iterations that haven't completed" do
    iteration = Generate.iteration "future iteration", :project => @project, :start_date => 3.weeks.from_now, :end_date => 4.weeks.from_now
    Generate.story :summary => "1 for future iteration", :bucket => iteration, :points => 300, :project => @project
    Generate.story :summary => "2 for future iteration", :bucket => iteration, :points => 400, :project => @project, :status => Status.complete
    average_velocity
  end
  
  it "treats unestimated stories for completed iterations as having zero point estimates" do
    iteration = @completed_iterations.first
    Generate.story :summary => "not estimated 1", :points => nil, :bucket => iteration, :project => @project, :status => Status.complete
    Generate.story :summary => "not estimated 2", :points => nil, :bucket => iteration, :project => @project, :status => Status.complete
    average_velocity    
  end
end

describe Project, "#completed_points" do
  before do
    Story.delete_all
    @project = Generate.project "foo"
    @completed_stories = [
      Generate.story(:summary => "story 1", :project => @project, :points => 1, :status => Status.complete),
      Generate.story(:summary => "story 2", :project => @project, :points => 2, :status => Status.complete),
      Generate.story(:summary => "story 3", :project => @project, :points => 4, :status => Status.complete) ]
    @not_completed_stories = [
      Generate.story(:summary => "story a", :project => @project, :points => 1) ]
  end
  
  it "returns the sum of points for completed stories that belong to this project" do
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  it "ignores points for stories that are defined" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.defined
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  it "ignores points for stories that are in_progress" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.in_progress
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  it "ignores points for stories that are rejected" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.rejected
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  it "ignores points for stories that are blocked" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.blocked
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  describe "with stories that belong to an iteration" do
    it "includes the points that belong to completed stories attached to an iteration" do
      iteration = Generate.iteration "iteration1", :project => @project
      story = Generate.story :summary => "story that belongs to iteration", :project => @project, :bucket => iteration, :points => 10, :status => Status.complete
      sum = @completed_stories.map(&:points).sum + story.points
      @project.completed_points.should == sum
    end
    
    it "ignores points that belong to incomplete stories attached to an iteration" do
      iteration = Generate.iteration "iteration1", :project => @project
      story = Generate.story :summary => "story that belongs to iteration", :project => @project, :bucket => iteration, :points => 10
      @project.completed_points.should == @completed_stories.map(&:points).sum
    end
  end
  
  describe "with stories that belong to a phase" do
    it "ignores points that belong to stories attached to a phase" do
      phase = Generate.phase "phase1", :project => @project
      story = Generate.story :summary => "story that belongs to phase", :project => @project, :bucket => phase, :points => 10
      story = Generate.story :summary => "story2 that belongs to phase", :project => @project, :bucket => phase, :points => 10, :status => Status.complete
      @project.completed_points.should == @completed_stories.map(&:points).sum
    end
  end
end

describe Project, "#remaining_points" do
  before do
    Story.delete_all
    @project = Generate.project "foo"
    @complete_stories = [
      Generate.story(:summary => "story 1", :project => @project, :points => 1, :status => Status.complete),
      Generate.story(:summary => "story 2", :project => @project, :points => 2, :status => Status.complete),
      Generate.story(:summary => "story 3", :project => @project, :points => 4, :status => Status.complete) ]
    @remaining_stories = [
      Generate.story(:summary => "story 1", :project => @project, :points => 1),
      Generate.story(:summary => "story 2", :project => @project, :points => 2) ]
  end
  
  it "returns the sum of points for incomplete stories belong to this project" do
    @project.remaining_points.should == @remaining_stories.map(&:points).sum
  end
  
  it "includes points for stories that are defined" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.defined
    @project.remaining_points.should == @remaining_stories.map(&:points).sum + story.points
  end

  it "includes points for stories that are in progress" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.in_progress
    @project.remaining_points.should == @remaining_stories.map(&:points).sum + story.points
  end

  it "ignores points for stories that are completed" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.complete
    @project.remaining_points.should == @remaining_stories.map(&:points).sum
  end

  it "includes points for stories that are blocked" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.blocked
    @project.remaining_points.should == @remaining_stories.map(&:points).sum + story.points
  end
  
  it "ignores points for stories that are rejected" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.rejected
    @project.remaining_points.should == @remaining_stories.map(&:points).sum
  end
  
  describe "with stories that belong to an iteration" do
    it "includes points that belong to incomplete stories attached to an iteration" do
      iteration = Generate.iteration "iteration1", :project => @project
      story = Generate.story :summary => "story that belongs to iteration", :project => @project, :bucket => iteration, :points => 10
      @project.remaining_points.should == @remaining_stories.map(&:points).sum + story.points
    end
  end
  
  describe "with stories that belong to a phase" do
    it "ignores points that belong to stories attached to a phase" do
      phase = Generate.phase "phase1", :project => @project
      story = Generate.story :summary => "story that belongs to phase", :project => @project, :bucket => phase, :points => 10
      @project.remaining_points.should == @remaining_stories.map(&:points).sum
    end
  end
end

describe Project, '#completed_iterations' do
  before do
    @project = Project.create :name=>"Project w/Activities"
    @completed_iterations = [
      Generate.iteration("iteration 1", :project => @project, :start_date => 4.weeks.ago, :end_date => 3.weeks.ago),
      Generate.iteration("iteration 2", :project => @project, :start_date => 2.weeks.ago, :end_date => 1.week.ago)
    ]
    Generate.iteration "iteration 3", :project => @project, :start_date => Time.now, :end_date => 1.week.from_now
    Generate.iteration "iteration 4", :project => @project, :start_date => 2.weeks.from_now, :end_date => 3.weeks.from_now
  end

  it "returns only iterations whose end_date are before today" do
    @project.completed_iterations.size.should == @completed_iterations.size
    @completed_iterations.each do |iteration|
      @project.completed_iterations.should include(iteration)
    end
  end
end

describe Project, "#recent_activities" do
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
    
    @story1 = Generate.story :summary => "story1", :project => @project
    @story2 = Generate.story :summary => "story2", :project => @project
    @story3 = Generate.story :summary => "story3", :project => @project ; @story3.move_higher #acts_as_list
    @story4 = Generate.story :summary => "story4", :project => @project, :bucket => @iteration
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
