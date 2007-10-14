require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before(:each) do
    @user = User.new
  end

  it "should be valid" do
    @user.group_id = 1
    @user.email_address = "me@me.com"
    @user.should be_valid
  end
  
  it "should always have a group id" do
    assert_validates_presence_of @user, :group_id
  end
  
  it "should always have an email address" do
    assert_validates_presence_of @user, :email_address
  end
  
  it "should belong a Group" do
    assert_association User, :belongs_to, :group, Group
  end
  
  it "should have many Stories" do
    assert_association User, :has_many, :stories, Story, :as => :responsible_party
  end
  
  it "should have many Projects" do
    assert_association User, :has_many, :projects, Project, 
       :source=>:project,
       :conditions => nil,
       :extend=>[],
       :class_name=>"Project",
       :limit=>nil,
       :order=>nil,
       :through=>:project_permissions,
       :group=>nil,
       :offset=>nil,
       :foreign_key=>"project_id"
  end
  
  it "should have many Project Permissions" do
    assert_association User, :has_many, :project_permissions, ProjectPermission, 
       :extend=>[],
       :dependent=>:destroy,
       :order=>nil,
       :class_name=>"ProjectPermission",
       :as=>:accessor,
       :conditions=>nil
  end
  

end
