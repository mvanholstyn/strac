require File.dirname(__FILE__) + '/../spec_helper'

describe TimeEntry do
  before do
    @time_entry = TimeEntry.new
  end

  it "is valid" do
    @time_entry.hours = 1
    @time_entry.date = Date.today
    @time_entry.should be_valid
  end
  
  it "has hours" do
    assert_validates_presence_of @time_entry, :hours
  end
  
  it "has a date" do
    assert_validates_presence_of @time_entry, :date
  end
  
  it "belongs to a Project" do
    assert_association TimeEntry, :belongs_to, :project, Project
  end
  
  describe "#timeable - polymorphic association" do
    it "associates with another model" do
      @user = Generate.user(:email_address => "Sally Jane")
      @time_entry = Generate.time_entry(:hours => 10.hours, :date => Date.today, :timeable=>@user)
      @time_entry.timeable.should be(@user)
    end
  end

end
