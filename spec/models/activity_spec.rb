require File.dirname(__FILE__) + '/../spec_helper'

describe Activity do
  before do
    @activity = Activity.new
  end

  it "is valid" do
    @activity.actor_id = 1
    @activity.action = "action"
    @activity.affected_id = 2
    @activity.affected_type = "Infectious"
    @activity.should be_valid
  end

  it "requires an actor id" do
    assert_validates_presence_of @activity, :actor_id
  end

  it "requires an action" do
    assert_validates_presence_of @activity, :action
  end

  it "requires an affected id" do
    assert_validates_presence_of @activity, :affected_id
  end
  
  it "requires an affected type" do
    assert_validates_presence_of @activity, :affected_type
  end

  it "belongs to a Project" do

  end

  it "belongs to an Actor (User)" do

  end
  
  describe "#affected - polymorphic association" do
    it "associates with another model" do
      @user = Generate.user(:email_address => "Sally Jane")
      @activity = Generate.activity(:action => "some action", :actor=>"some user", :affected=>@user)
      @activity.affected.should be(@user)
    end
  end
end
