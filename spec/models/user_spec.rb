require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before(:each) do
    @user = User.new
  end
  
  describe "validations" do
    it "can be valid" do
      user = User.new(
        :group_id => 1,
        :email_address =>"me@example.com",
        :first_name => "Bob",
        :last_name => "Joe"
      )
    end
    
    it "requires a first name" do
      @user.should validate_presence_of(:first_name)
    end

    it "requires a last name" do
      @user.should validate_presence_of(:last_name)
    end
    
    it "requires a group_id" do
      @user.should validate_presence_of(:group_id)
    end
    
    it "requires an email address" do
      @user.should validate_presence_of(:email_address)      
    end
  end
    
end
