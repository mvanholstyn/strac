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
