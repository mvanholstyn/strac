require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before(:each) do
    @user = User.new
  end
  
  it "requires a unique email address"

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
  
end
