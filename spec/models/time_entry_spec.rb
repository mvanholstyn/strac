require File.dirname(__FILE__) + '/../spec_helper'

describe TimeEntry do
  before(:each) do
    @time_entry = TimeEntry.new
  end

  it "should be valid" do
    @time_entry.hours = 1
    @time_entry.date = Date.today
    @time_entry.should be_valid
  end
  
  it "should always have hours" do
    assert_validates_presence_of @time_entry, :hours
  end
  
  it "should always have a date" do
    assert_validates_presence_of @time_entry, :date
  end
  
  it "should belong to a Project" do
    assert_association TimeEntry, :belongs_to, :project, Project
  end
  
  it "should belong to a timeable (polymorphic)"
end
