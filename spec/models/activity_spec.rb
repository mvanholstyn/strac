require File.dirname(__FILE__) + '/../spec_helper'

describe Activity do
  before(:each) do
    @activity = Activity.new
  end

  it "should be valid" do
    @activity.actor_id = 1
    @activity.action = "action"
    @activity.affected_id = 2
    @activity.affected_type = "Infectious"
    @activity.should be_valid
  end

  it "should require an actor id" do
    assert_validates_presence_of @activity, :actor_id
  end

  it "should require an action" do
    assert_validates_presence_of @activity, :action
  end

  it "should require an affected id" do
    assert_validates_presence_of @activity, :affected_id
  end
  
  it "should require an affected type" do
    assert_validates_presence_of @activity, :affected_type
  end

  it "should belong to a Project" do
    assert_association Activity, :belongs_to, :project, Project
  end

  it "should belong to an Actor (User)" do
    assert_association Activity, :belongs_to, :actor, User, :class_name=>"User", :foreign_key => "actor_id"
  end
  
  it "should belong to an affected (polymorphic)"
  
end
