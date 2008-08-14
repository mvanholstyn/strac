require File.dirname(__FILE__) + '/../spec_helper'

describe Project, "#new with no attributes" do
  before do
    @project = Project.new
  end

  it "should not be valid" do
    @project.should_not be_valid
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

describe Project, "starting a new iteration" do
  it "creates a new iteration" do
    project = Generate.project
    lambda {
      iteration = project.start_new_iteration!
      project.iterations.current.should == iteration
    }.should change(Iteration, :count).by(1)
  end
  
  context "when a previous iteration exists" do
    it "ends the previous iteration" do
      project = Generate.project :iterations => []
      project.iterations.find_or_build_current.save!
      iteration = project.iterations.current
      iteration.ended_at.should be_nil
      
      new_iteration = project.start_new_iteration!
      iteration.reload
      iteration.ended_at.should_not be_nil
      iteration.ended_at.should <= new_iteration.started_at
    end
    
    it "builds a snapshot for the previous iteration" do
      project = Generate.project :iterations => []
      iteration = project.iterations.find_or_build_current
      iteration.save!
      project.stub!(:total_points).and_return(1)
      project.stub!(:completed_points).and_return(2)
      project.stub!(:remaining_points).and_return(3)
      project.stub!(:average_velocity).and_return(4)
      project.stub!(:estimated_remaining_iterations).and_return(5)
      project.stub!(:estimated_completion_date).and_return(1.year.ago.to_date)

      new_iteration = project.start_new_iteration!

      snapshot = new_iteration.snapshot
      snapshot.total_points.should == 1
      snapshot.completed_points.should == 2
      snapshot.remaining_points.should == 3
      snapshot.average_velocity.should == 4
      snapshot.estimated_remaining_iterations.should == 5
      snapshot.estimated_completion_date.should == 1.year.ago.to_date
    end
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

describe Project, '#completed_iterations' do
  before do
    @project = Project.create :name=>"Project w/Activities"
    @completed_iterations = [
      Generate.iteration(:name => "iteration 1", :project => @project, :started_at => 4.weeks.ago, :ended_at => 3.weeks.ago),
      Generate.iteration(:name => "iteration 2", :project => @project, :started_at => 2.weeks.ago, :ended_at => 1.week.ago)
    ]
    Generate.iteration :name => "iteration 3", :project => @project, :started_at => Time.now, :ended_at => 1.week.from_now
    Generate.iteration :name => "iteration 4", :project => @project, :started_at => 2.weeks.from_now, :ended_at => 3.weeks.from_now
  end

  it "returns only iterations whose ended_at are before today" do
    @project.completed_iterations.size.should == @completed_iterations.size
    @completed_iterations.each do |iteration|
      @project.completed_iterations.should include(iteration)
    end
  end
end

describe Project, "#recent_activities" do
  def recent_activities(*args)
    @project.recent_activities *args
  end
  
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
  
  describe "when no arguments are given" do
    it "returns only project activities from within the past day when given no arguments" do
      @project.recent_activities.should ==  [@activity1, @activity2]
    end
  end
  
  describe "when an argument is given" do
    it "returns project activities which originated within the past in timeframe" do
      @project.recent_activities(2.days).should == [@activity1, @activity2, @activity3]
      @project.recent_activities(1.week).should == [@activity1, @activity2, @activity3, @activity4]
    end
  end
end

describe Project, "iterations_ordered_by_started_at" do
  before do
    @project = Generate.project :name => "ProjectA"
    @iteration1 = (Generate.iteration :name => "Iteration5", :project => @project, :started_at => Date.today - 3.weeks)
    @iteration3 = (Generate.iteration :name => "Iteration5", :project => @project, :started_at => Date.today - 1.week)
    @iteration2 = (Generate.iteration :name => "Iteration5", :project => @project, :started_at => Date.today - 2.weeks)
    @project.iterations = [ @iteration1, @iteration3, @iteration2 ]
    @project.save!
  end
  
  it "returns all iterations ordered by their start date" do
    @project.iterations_ordered_by_started_at.should == [ @iteration1, @iteration2, @iteration3 ]
  end
end

describe Project, "#backlog_stories" do
  before do
    @project = Generate.project :name => "ProjectA"
    @iteration = Generate.iteration :name => "Iteration1", :project => @project
    
    @story1 = Generate.story :summary => "story1", :project => @project
    @story2 = Generate.story :summary => "story2", :project => @project
    @story3 = Generate.story :summary => "story3", :project => @project ; @story3.move_higher #acts_as_list
    @story4 = Generate.story :summary => "story4", :project => @project, :bucket => @iteration
  end
  
  it "returns all of the project not assigned to an iteration ordered by position" do
    @project.backlog_stories.should == [ @story1, @story3, @story2 ]
  end
end

describe Project, "#backlog_iteration" do
  before do
    @project = Generate.project :name => "ProjectA"
    @backlog = @project.backlog_iteration
  end
  
  it "returns a new Iteration" do
    @backlog.new_record?.should be_true
  end
  
  describe "the returned iteration" do
    it "has a name of 'Backlog'" do
      @backlog.name.should == "Backlog"
    end
  end
end

describe Project, '#update_members' do
  before do
    @members = [ Generate.user, Generate.user, Generate.user ]
    @project = Generate.project :name => "Foo", :members => @members
    @project.users.should == @members
  end
  
  it "grants permissions on the project to only the users with the passed ids" do
    @project.update_members [@members.first.id, @members.last.id]
    @project.users.reload.should == [@members.first, @members.last]
  end    
  
  it "does nothing when passed a blank value" do
    @project.update_members ""
    @project.users.should == @members
    @project.update_members nil
    @project.users.should == @members
  end
end

describe Project, '#incomplete_stories' do
  def incomplete_stories
    @project.incomplete_stories
  end
  
  before do
    @project = Generate.project
    @incomplete_stories = []
    story_count = 3
    story_count.times do |i|
      @incomplete_stories << Generate.story(:project => @project) 
      @incomplete_stories.last.update_attribute(:position, story_count - i)
    end
    @sorted_incomplete_stories = @incomplete_stories.sort_by{ |story| story.position }
  end
  
  it "returns incomplete stories ordered by position" do
    incomplete_stories.should == @sorted_incomplete_stories
    incomplete_stories.zip(@sorted_incomplete_stories) do |actual, expected|
      actual.should == expected
    end
  end
  
  describe "when stories are completed" do
    before do
      @completed_stories = []
      3.times { @completed_stories << Generate.story(:project => @project, :status => Status.complete) }
    end
    
    it "does not include completed stories" do
      incomplete_stories.should == @sorted_incomplete_stories
    end
  end
end

describe Project, "#iterations" do
  before do
    @project = Generate.project
  end

  it "can generate a dummy backlog iteration" do
    backlog = @project.iterations.backlog
    backlog.id.should be_nil
    backlog.name.should == "Backlog"
  end

  describe "returning the current iteration" do
    it "returns an iteration that started today and does not have an end date" do
      iteration = Generate.iteration :project => @project, :started_at => Time.now, :ended_at => nil
      @project.iterations.current.should == iteration      
    end
    
    it "returns an iteration that started before today and does not have an end date" do
      iteration = Generate.iteration :project => @project, :started_at => 1.weeks.ago, :ended_at => nil
      @project.iterations.current.should == iteration
    end
    
    it "does not return an iteration that has a start date" do
      iteration = Generate.iteration :project => @project, :started_at => 1.weeks.ago, :ended_at => Time.now
      @project.iterations.current.should be_nil

      @project.iterations.clear
      iteration = Generate.iteration :project => @project, :started_at => Time.now, :ended_at => 1.day.from_now
      @project.iterations.current.should be_nil
    end
  end

  it "can return the iteration with the second latest start date as the previous iteration" do
    @project.iterations.clear
    @previous_iteration = Generate.iteration :project => @project, :started_at => 2.weeks.ago, :ended_at => 1.weeks.ago
    current_iteration = Generate.iteration :project => @project, :started_at => Date.today, :ended_at => nil
    @project.iterations.previous.should == @previous_iteration
  end

  it "can find or build the current iteration" do
    now = Time.now
    Time.stub!(:now).and_return(now)
    current_iteration = Generate.iteration :project => @project, :started_at => 1.day.ago, :ended_at => nil
    @project.iterations.find_or_build_current.should == current_iteration
    
    @project.iterations.clear
    @project.iterations.should be_empty
    iteration = @project.iterations.find_or_build_current
    iteration.started_at.should == now
    iteration.ended_at.should be_nil
  end
end

