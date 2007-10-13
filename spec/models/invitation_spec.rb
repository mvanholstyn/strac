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
  
  it "should be valid" do
    @invitation.update_attributes :inviter_id=>1, :project_id=>2
    @invitation.should be_valid
  end

end

describe Invitation, "#create_for - creating a single invitation" do
  def create_invitations
    @invitations = Invitation.create_for(@project, @user, @email_address)    
  end

  before do
    @project = mock_model(Project)
    @user = mock_model(User)
    
    UniqueCodeGenerator.stub!(:generate)
    
    @email_address = "user@example.com"
  end

  it "creates a single invitation when given a single email address" do
    create_invitations
    @invitations.size.should == 1
    @invitations.first.recipient.should == @email_address
  end
  
  it "assigns the passed in project to the invitation" do
    create_invitations
    @invitations.first.project_id.should == @project.id
  end
  
  it "assigns the passed in user as the inviter of the invitation" do
    create_invitations
    @invitations.first.inviter_id.should == @user.id
  end
  
  it "assigns a unique code to the invitation" do
    unique_code = "blahblah"
    UniqueCodeGenerator.should_receive(:generate).with(@email_address).and_return(unique_code)
    create_invitations
    @invitations.first.code.should == unique_code
  end
  
end    

describe Invitation, "#create_for - creating multiple invitations at a time" do
  def create_invitations
    @invitations = Invitation.create_for(@project, @user, @email_addresses.join(" , "))
  end
  
  before do
    @project = mock_model(Project)
    @user = mock_model(User)

    UniqueCodeGenerator.stub!(:generate)
        
    @email_addresses = ["user@example.com", "foo@blah.com"]
  end

  it "creates an invitation for each passed in email address" do
    create_invitations
    @invitations.size.should == 2
    @invitations.first.recipient.should == @email_addresses.first
    @invitations.last.recipient.should == @email_addresses.last
  end
  
  it "assigns the passed in project to each invitation" do
    create_invitations
    @invitations.first.project_id.should == @project.id
    @invitations.last.project_id.should == @project.id
  end
  
  it "assigns the passed in user as the inviter of each invitation" do
    create_invitations
    @invitations.first.inviter_id.should == @user.id
    @invitations.last.inviter_id.should == @user.id
  end
  
  it "assigns a unique code to the invitations" do
    unique_code = "blahblah"
    another_unique_code = "blahblahblah"
    UniqueCodeGenerator.should_receive(:generate).with(@email_addresses.first).and_return(unique_code)
    UniqueCodeGenerator.should_receive(:generate).with(@email_addresses.last).and_return(another_unique_code)
    create_invitations
    @invitations.first.code.should == unique_code
    @invitations.last.code.should == another_unique_code
  end
end