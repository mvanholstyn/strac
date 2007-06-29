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
    assert_association Group, :has_many, :users, User
  end
  
  it "should have many Privilege" do
    assert_association Group, :has_many, :privileges, Privilege, :through => :group_privileges
  end
  
  it "should have many Group Privileges" do
    assert_association Group, :has_many, :group_privileges, GroupPrivilege, :dependent=>:destroy
  end

end
