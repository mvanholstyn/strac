require File.dirname(__FILE__) + '/../spec_helper'

describe Iteration do
  before do
    @iteration = Iteration.new
  end

  it "is a Bucket" do
    Iteration.new.should be_kind_of(Bucket)
  end

  it "is valid with a name, project_id, start_date and end_date" do
    @iteration.name = "Iteration 1"
    @iteration.project_id = 1
    @iteration.start_date = Date.today
    @iteration.end_date = Date.today + 1
    @iteration.should be_valid
  end

  it "should always have a start date" do
    assert_validates_presence_of @iteration, :start_date
  end

  it "should have have a start date that comes before its end date" do
    @iteration.start_date = Date.today
    @iteration.end_date = Date.today - 1
    @iteration.should_not be_valid
    @iteration.errors.on(:base).should include("start date must be before end date")
  end

  it "should have a budget" do
    @iteration.budget = 25
    @iteration.budget.should == 25
  end
end

describe Iteration do
  before do
    Iteration.destroy_all
    Story.destroy_all
    @first_iteration = Iteration.create!( :project_id => 1, :start_date => Date.today, :end_date => Date.today + 7, :name => "Iteration 1" )
    @first_iteration.should be_valid
    
    @second_iteration = Iteration.new( :project_id => 1, :start_date => Date.today, :end_date => Date.today+14, :name => "Iteration 1" )
    @second_iteration.should_not be_valid
  end
      
  it "should never overlap another iteration" do
    @second_iteration.errors.on(:base).should == "Iterations cannot overlap"

    @second_iteration.start_date = Date.today + 3
    @second_iteration.should_not be_valid
    @second_iteration.errors.on(:base).should == "Iterations cannot overlap"

    @second_iteration.start_date = Date.today + 7
    @second_iteration.should_not be_valid
    @second_iteration.errors.on(:base).should == "Iterations cannot overlap"
  end
end

describe Iteration, "#points_completed" do
  fixtures :statuses

  def points_completed
    @iteration.points_completed
  end

  before do
    @iteration = Iteration.create!(:project_id => 1, :start_date => Date.today, :end_date => Date.today+1, :budget => 25, :name => "Iteration 1")    
  end
  
  describe "with no stories" do
    before do
      Iteration.destroy_all
      Story.destroy_all
    end

    it "returns 0" do
      points_completed.should == 0    
    end
  end
  
  describe "with no completed stories" do
    before do
      @iteration.stories << Story.create!(:status_id=>Status.blocked.id, :points=>10, :project_id=>@iteration.project_id, :summary=>"Story 1")
      @iteration.stories << Story.create!(:status_id=>Status.rejected.id, :points=>7, :project_id=>@iteration.project_id, :summary=>"Story 2")
      @iteration.stories << Story.create!(:status_id=>Status.defined.id, :points=>5, :project_id=>@iteration.project_id, :summary=>"Story 3")
      @iteration.stories << Story.create!(:status_id=>Status.in_progress.id, :points=>5, :project_id=>@iteration.project_id, :summary=>"Story 3")
    end
    
    it "returns 0" do
      points_completed.should == 0    
    end
  end
  
  describe "with completed stories" do
    before do
      @iteration.stories << Story.create!(:status_id=>Status.complete.id, :points=>10, :project_id=>@iteration.project_id, :summary=>"Story 1")
      @iteration.stories << Story.create!(:status_id=>Status.complete.id, :points=>7, :project_id=>@iteration.project_id, :summary=>"Story 2")
      @iteration.stories << Story.create!(:status_id=>Status.complete.id, :points=>5, :project_id=>@iteration.project_id, :summary=>"Story 3")
    end

    it "returns the sum of completed story points" do
      points_completed.should == 22
    end
  end

end

describe Iteration, '#total_points' do
  fixtures :statuses

  def total_points
    @iteration.total_points
  end

  before do
    @iteration = Generate.iteration(:start_date => Date.today, :end_date => Date.today+1.week, :budget => 25, :name => "Iteration 1")
    @iteration.stories << Story.create!(:status_id=>Status.complete.id, :points=>10, :project_id=>@iteration.project_id, :summary=>"Story 1")
    @iteration.stories << Story.create!(:status_id=>Status.defined.id, :points=>5, :project_id=>@iteration.project_id, :summary=>"Story 2")
  end

  it "returns the total number of story points" do
    total_points.should == 15
  end
end

describe Iteration, '#points_remaining' do
  fixtures :statuses
  
  def points_remaining
    @iteration.points_remaining
  end

  before do
    @iteration = Generate.iteration(:start_date => Date.today, :end_date => Date.today+1.week, :budget => 25, :name => "Iteration 1")
    @iteration.stories << Story.create!(:status_id=>Status.complete.id, :points=>10, :project_id=>@iteration.project_id, :summary=>"Story 1")
    @iteration.stories << Story.create!(:status_id=>Status.defined.id, :points=>5, :project_id=>@iteration.project_id, :summary=>"Story 2")
  end
  
  it "returns the number of remaining story points" do
    points_remaining.should == 5
  end
end

describe Iteration, '#points_before_iteration' do
  fixtures :statuses
  
  def points_before_iteration
    @iteration.points_before_iteration
  end
  
  before do
    @iteration = Generate.iteration(:start_date => Date.today, :end_date => Date.today+1.week, :budget => 25, :name => "Iteration 1")
    @iteration.stories << Story.create!(:status_id=>Status.complete.id, :points=>10, :project_id=>@iteration.project_id, :summary=>"Story 1")
    @iteration.stories << Story.create!(:status_id=>Status.defined.id, :points=>5, :project_id=>@iteration.project_id, :summary=>"Story 2")
    Story.create!(:created_at=>Date.today-1, :status_id=>Status.complete.id, :points=>2, :project_id=>1, :summary=>"Story from yesterday", :project => @iteration.project)
    Story.create!(:created_at=>Date.today-7, :status_id=>Status.defined.id, :points=>3, :project_id=>1, :summary=>"Story from last week", :project => @iteration.project)
  end
  
  it "returns the number story points that existed before the iteration's start date" do
    points_before_iteration.should == 5
  end
end

describe Iteration, '#display_name' do
  before do
    @start_date = Time.now.yesterday
    @end_date = Time.now
  end
  
  describe "with a blank name" do
    before do
      @iteration = Iteration.new :start_date => @start_date, :end_date => @end_date
    end
    
    it "returns a string in the form of 'YY-MM-DD through YY-MM-DD" do
      n = @iteration.display_name
      n.should == @start_date.strftime( "%Y-%m-%d" ) + " through " + @end_date.strftime( "%Y-%m-%d" )
    end
  end
  
  describe "with a name" do
    before do
      @name = "FooBaz"
      @iteration = Iteration.new :name => @name, :start_date => @start_date, :end_date => @end_date
    end
    
    it "returns a string in the form of 'name (YY-MM-DD through YY-MM-DD)" do
      n = @iteration.display_name
      n.should == "#{@name} (#{@start_date.strftime( "%Y-%m-%d" )} through #{@end_date.strftime( "%Y-%m-%d" )})"    
    end
  end
end

