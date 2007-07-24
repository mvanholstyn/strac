require File.dirname(__FILE__) + '/../spec_helper'

describe Project do
  before do
    @project = Project.new
  end

  it "should be valid" do
    @project.should be_valid
  end

  it "should have many invitations" do
    assert_association Project, :has_many, :invitations, Invitation
  end
  
end

describe Project, "recent_activities" do
  fixtures :users
  
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