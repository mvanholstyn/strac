require File.dirname(__FILE__) + '/../spec_helper'

describe Invitation do
  before do
    @invitation = Invitation.new
  end
  
  it "should belong to an inviter" do
    assert_association Invitation, :belongs_to, :inviter, User, :class_name => "User", :foreign_key => "inviter_id"
  end
  
  it "should belong to a project" do
    assert_association Invitation, :belongs_to, :project, Project
  end  
  
  it "should always have a project" do
    assert_validates_presence_of @invitation, :project_id
  end

  it "should always have a inviter" do
    assert_validates_presence_of @invitation, :inviter_id
  end
  
  it "should be valid" do
    @invitation.update_attributes :inviter_id=>1, :project_id=>2
    @invitation.should be_valid
  end
end


describe Invitation, "#accept_invitation_url" do
  it "is a readable/writable accessor" do
    url = stub("URL")
    invitation = Invitation.new
    invitation.accept_invitation_url = url
    invitation.accept_invitation_url.should == url
  end
  
  it "is not saved to the database" do
    invitation = Generate.invitation "foo@blah.com"
    invitation.accept_invitation_url = "http://some url here"
    invitation.save!
    invitation2 = Invitation.find(invitation.id)
    invitation2.accept_invitation_url.should be_nil
  end
end