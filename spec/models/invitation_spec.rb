require File.dirname(__FILE__) + '/../spec_helper'

describe Invitation do
  before(:each) do
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

  it "should always have a kind" do
    assert_validates_presence_of @invitation, :kind
  end

  it "should be valid" do
    @invitation.update_attributes :kind=>"KIND", :inviter_id=>1, :project_id=>2
    @invitation.should be_valid
  end

end

describe "Project" do
  before(:each) do
    @project = Project.create :id=>1
  end

  it "should build no invitations with nil" do
     invitations = @project.invitations.build_from_string( nil, :inviter_id => 1, :kind => "customer" )
     invitations.size.should == 0    
  end

  it "should build no invitations with an empty string" do
     invitations = @project.invitations.build_from_string( "\n\n\n\n", :inviter_id => 1, :kind => "customer" )
     invitations.size.should == 0
  end

  it "should build no emails with empty lines" do
     invitations = @project.invitations.build_from_string( "", :inviter_id => 1, :kind => "customer" )
     invitations.size.should == 0    
  end
  
  it "should build with a single email address" do
    invitations = @project.invitations.build_from_string( "user@example.com", :inviter_id => 1, :kind => "customer" )
    invitations.size.should == 1
    invitations.first.recipient.should == ("user@example.com")
  end

  it "should build with multiple email addresses" do
    invitations = @project.invitations.build_from_string( "user@example.com\nuser2@example.com", :inviter_id => 1, :kind => "customer" )
    invitations.size.should == 2
    invitations.first.recipient.should == "user@example.com"
    invitations.last.recipient.should == "user2@example.com"
  end

  
end    
  