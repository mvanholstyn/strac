require File.dirname(__FILE__) + '/../spec_helper'


describe Iteration do
  before(:each) do
    @iteration = Iteration.new
  end

  it "should be valid" do
    @iteration.name = "Iteration 1"
    @iteration.project_id = 1
    @iteration.start_date = Date.today
    @iteration.end_date = Date.today + 1
    @iteration.should be_valid
  end

  it "should always have a start date" do
    assert_validates_presence_of @iteration, :start_date
  end

  it "should always have a end date" do
    assert_validates_presence_of @iteration, :end_date
  end
  
  it "should always belong to a project" do
    assert_validates_presence_of @iteration, :project_id
  end

  it "should always have a name" do
    assert_validates_presence_of @iteration, :name
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


describe "Iterations" do
  before(:each) do
    Iteration.destroy_all
    Story.destroy_all
    @first_iteration = Iteration.create!( :project_id => 1, :start_date => Date.today, :end_date => Date.today + 7, :name => "Iteration 1" )
    @first_iteration.should be_valid
    
    @second_iteration = Iteration.new( :project_id => 1, :start_date => Date.today, :end_date => Date.today+14, :name => "Iteration 1" )
    @second_iteration.should_not be_valid
  end
      
  they "should never overlap" do
    @second_iteration.errors.on(:base).should == "Iterations cannot overlap"

    @second_iteration.start_date = Date.today + 3
    @second_iteration.should_not be_valid
    @second_iteration.errors.on(:base).should == "Iterations cannot overlap"

    @second_iteration.start_date = Date.today + 7
    @second_iteration.should_not be_valid
    @second_iteration.errors.on(:base).should == "Iterations cannot overlap"
  end
end

describe "Iteration with no stories" do
  fixtures :statuses

  before(:each) do
    Iteration.destroy_all
    Story.destroy_all
    @iteration = Iteration.create!(:project_id => 1, :start_date => Date.today, :end_date => Date.today+1, :budget => 25, :name => "Iteration 1")
  end

  it "should have 0 points" do
    @iteration.points_completed.should == 0    
  end
end

describe "Iteration with stories" do
  fixtures :statuses

  before(:each) do
    Iteration.destroy_all
    Story.destroy_all
    @iteration = Iteration.create!(:project_id => 1, :start_date => Date.today, :end_date => Date.today+1, :budget => 25, :name => "Iteration 1")
    @iteration.stories << Story.create!(:status_id=>Status.complete.id, :points=>10, :project_id=>1, :summary=>"Story 1")
    @iteration.stories << Story.create!(:status_id=>Status.defined.id, :points=>5, :project_id=>1, :summary=>"Story 2")
  end

  it "should compute the total number of story points" do
    @iteration.total_points.should == 15
  end

  it "should sum the number of completed story points" do
    @iteration.points_completed.should == 10
  end

  it "should compute the number of remaining story points" do
    @iteration.points_remaining.should == 5
  end
  
  it "should create the number of story points that existed before the iteration start date" do
    Story.create!(:created_at=>Date.today-1, :status_id=>Status.complete.id, :points=>2, :project_id=>1, :summary=>"Story from yesterday")
    Story.create!(:created_at=>Date.today-7, :status_id=>Status.defined.id, :points=>3, :project_id=>1, :summary=>"Story from last week")
    
    @iteration.points_before_iteration.should == 5
  end
end