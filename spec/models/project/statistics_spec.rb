require File.dirname(__FILE__) + '/../../spec_helper'

describe Project, '#average_velocity' do
  def average_velocity
    @project.average_velocity
  end
  
  before do
    @project = Generate.project
    @current_iteration = stub("current iteration", :started_at => Time.now)
    @past_iterations = [stub("past iteration 1", :points_completed => 0), stub("past iteration 2", :points_completed => 0)]
    @iterations = []
    @iterations.stub!(:find_or_build_current).and_return(@current_iteration)
    @iterations.stub!(:find).and_return(@past_iterations)
    @iterations_calculator = stub("iterations calculator")
    @project.stub!(:iterations).and_return(@iterations)
  end
    
  it "finds or builds the current iteration" do
    @project.iterations.should_receive(:find_or_build_current).and_return(@current_iteration)
    average_velocity
  end
  
  it "finds all previous iterations, ending before the start of the current iteration" do
    @project.iterations.should_receive(:find).with(
      :all, 
      :conditions=>["ended_at < ? ", @current_iteration.started_at], 
      :order => "started_at ASC"
    ).and_return(@past_iterations)
    average_velocity
  end

  it "computes the sum of completed story points for each of the past iterations" do
    @past_iterations.each do |iteration|
      iteration.should_receive(:points_completed).and_return(0)
    end
    average_velocity
  end
  
  it "calculates the average velocity" do
    points = []
    @past_iterations.each_with_index do |iteration, i|
      sum = 1+i
      iteration.stub!(:points_completed).and_return(sum)
      points << sum
    end
    VelocityCalculator.should_receive(:compute_weighted_average).with(points)
    average_velocity
  end
  
  it "returns the computed average velocity" do
    VelocityCalculator.stub!(:compute_weighted_average).and_return(:computed_average)
    average_velocity.should == :computed_average
  end
end

describe Project, "#total_points" do
  before do
    Story.delete_all
    @project = Generate.project :name => "foo"
    @stories = [
      Generate.story(:summary => "story 1", :project => @project, :points => 1),
      Generate.story(:summary => "story 2", :project => @project, :points => 2),
      Generate.story(:summary => "story 3", :project => @project, :points => 4) ]
  end
  
  it "returns the sum of points for stories that belong to this project" do
    @project.total_points.should == @stories.map(&:points).sum
  end

  it "includes points for stories that are defined in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.defined
    @project.total_points.should == @stories.map(&:points).sum + story.points
  end

  it "includes points for stories that are in progress in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.in_progress
    @project.total_points.should == @stories.map(&:points).sum + story.points
  end

  it "includes points for stories that are complete in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.complete
    @project.total_points.should == @stories.map(&:points).sum + story.points
  end

  it "includes points for stories that are blocked in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.blocked
    @project.total_points.should == @stories.map(&:points).sum + story.points
  end
  
  it "ignores points for stories that are rejected in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.rejected
    @project.total_points.should == @stories.map(&:points).sum
  end
  
  describe "with stories that belong to an iteration" do
    it "includes the points that belong to stories attached to an iteration in the returned sum" do
      iteration = Generate.iteration :name => "iteration1", :project => @project
      story = Generate.story :summary => "story that belongs to iteration", :project => @project, :bucket => iteration, :points => 10
      @project.total_points.should == @stories.map(&:points).sum + story.points
    end
  end
  
  describe "with stories that belong to a phase" do
    it "does not include points that belong to stories attached to a phase in the returned sum" do
      phase = Generate.phase :name => "phase1", :project => @project
      story = Generate.story :summary => "story that belongs to phase", :project => @project, :bucket => phase, :points => 10
      @project.total_points.should == @stories.map(&:points).sum
    end
  end
end

describe Project, "#completed_points" do
  before do
    Story.delete_all
    @project = Generate.project :name => "foo"
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

  it "ignores points for stories that are defined in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.defined
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  it "ignores points for stories that are in_progress in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.in_progress
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  it "ignores points for stories that are rejected in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.rejected
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  it "ignores points for stories that are blocked in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.blocked
    @project.completed_points.should == @completed_stories.map(&:points).sum
  end

  describe "with stories that belong to an iteration" do
    it "includes the points that belong to completed stories attached to an iteration in the returned sum" do
      iteration = Generate.iteration :name => "iteration1", :project => @project
      story = Generate.story :summary => "story that belongs to iteration", :project => @project, :bucket => iteration, :points => 10, :status => Status.complete
      sum = @completed_stories.map(&:points).sum + story.points
      @project.completed_points.should == sum
    end
    
    it "ignores points that belong to incomplete stories attached to an iteration in the returned sum" do
      iteration = Generate.iteration :name => "iteration1", :project => @project
      story = Generate.story :summary => "story that belongs to iteration", :project => @project, :bucket => iteration, :points => 10
      @project.completed_points.should == @completed_stories.map(&:points).sum
    end
  end
  
  describe "with stories that belong to a phase" do
    it "ignores points that belong to stories attached to a phase in the returned sum" do
      phase = Generate.phase :name => "phase1", :project => @project
      story = Generate.story :summary => "story that belongs to phase", :project => @project, :bucket => phase, :points => 10
      @project.completed_points.should == @completed_stories.map(&:points).sum
    end
  end
end

describe Project, "#remaining_points" do
  before do
    Story.delete_all
    @project = Generate.project :name => "foo"
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
  
  it "includes points for stories that are defined in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.defined
    @project.remaining_points.should == @remaining_stories.map(&:points).sum + story.points
  end

  it "includes points for stories that are in progress in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.in_progress
    @project.remaining_points.should == @remaining_stories.map(&:points).sum + story.points
  end

  it "ignores points for stories that are completed in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.complete
    @project.remaining_points.should == @remaining_stories.map(&:points).sum
  end

  it "includes points for stories that are blocked in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.blocked
    @project.remaining_points.should == @remaining_stories.map(&:points).sum + story.points
  end
  
  it "ignores points for stories that are rejected in the returned sum" do
    story = Generate.story :summary => "story", :project => @project, :points => 10, :status => Status.rejected
    @project.remaining_points.should == @remaining_stories.map(&:points).sum
  end
  
  describe "with stories that belong to an iteration" do
    it "includes points that belong to incomplete stories attached to an iteration in the returned sum" do
      iteration = Generate.iteration :name => "iteration1", :project => @project
      story = Generate.story :summary => "story that belongs to iteration", :project => @project, :bucket => iteration, :points => 10
      @project.remaining_points.should == @remaining_stories.map(&:points).sum + story.points
    end
  end
  
  describe "with stories that belong to a phase" do
    it "ignores points that belong to stories attached to a phase in the returned sum" do
      phase = Generate.phase :name => "phase1", :project => @project
      story = Generate.story :summary => "story that belongs to phase", :project => @project, :bucket => phase, :points => 10
      @project.remaining_points.should == @remaining_stories.map(&:points).sum
    end
  end
end
