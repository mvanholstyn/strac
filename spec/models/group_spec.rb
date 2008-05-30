require File.dirname(__FILE__) + '/../spec_helper'

describe Group do
  before(:each) do
    @group = Group.new
  end

  it "should be valid" do
    @group.name = "Group1"
    @group.should be_valid
  end

  it "should always have a name" do
    assert_validates_presence_of @group, :name
  end

  it "should have many Users" do

  end
  
  it "should have many Privilege" do

  end
  
  it "should have many Group Privileges" do

  end

end
