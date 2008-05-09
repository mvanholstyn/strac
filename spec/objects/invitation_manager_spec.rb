require File.dirname(__FILE__) + '/../spec_helper'

describe InvitationManager, ".store_pending_invitation_acceptance" do
  it "should call #store_pending_invitation_acceptance on the instance" do
    session = stub("session")
    code = stub("invitation code")
    InvitationManager.instance.should_receive(:store_pending_invitation_acceptance).with(session, code)
    InvitationManager.store_pending_invitation_acceptance(session, code)
  end
end

describe InvitationManager, "#store_pending_invitation_acceptance with non-nil invitation code" do
  before do
    @target = InvitationManager.instance
  end
  
  it "should store the passed in invitation codes in the passed in session" do
    session = stub("session")
    code = stub("invitation code")
    session.should_receive(:[]=).with(:pending_invite_code, code)        
    @target.store_pending_invitation_acceptance(session, code)
  end
  
end

describe InvitationManager, ".accept_pending_invitations" do
  it "should call #accept_pending_invitations on the instance" do
    session = stub("session")
    user = stub("user")
    InvitationManager.instance.should_receive(:accept_pending_invitations).with(session, user)
    InvitationManager.accept_pending_invitations(session, user)
  end
end

describe InvitationManager, "#accept_pending_invitations without a pending invite code" do
  before do
    @session = stub("session")
    @user = stub("user")
    @target = InvitationManager.instance
  end
  
  it "does nothing and returns nil" do
    @session.should_receive(:[]).with(:pending_invite_code).and_return(nil)
    result = @target.accept_pending_invitations(@session, @user)
    result.should be_nil
  end
end

describe InvitationManager, "#accept_pending_invitations with pending invite code" do
  before do
    @session = stub("session", :[] => "pending invite code", :[]= => "")
    @user = stub("user", :projects => [])
    @invitation = stub("invitation", :project_id => 1)
    @project = stub("project", :name => stub("project name"))

    @target = InvitationManager.instance
    Invitation.stub!(:find_by_code).and_return(@invitation)
    Project.stub!(:find).and_return(@project)
  end
  
  it "finds the invitation for the pending invite code" do
    @pending_invite_code = stub("pending invite code")

    @session.should_receive(:[]).with(:pending_invite_code).and_return(@pending_invite_code)
    Invitation.should_receive(:find_by_code).with(@pending_invite_code).and_return(@invitation)
    
    @target.accept_pending_invitations(@session, @user)
  end

  it "assigns the project associated with the invitation to the user" do
    @project_id = stub("project id")
    @user_projects = stub("user projects")

    @invitation.should_receive(:project_id).and_return(@project_id)
    Project.should_receive(:find).with(@project_id).and_return(@project)
    @user.should_receive(:projects).and_return(@user_projects)
    @user_projects.should_receive(:<<).with(@project)
    
    @target.accept_pending_invitations(@session, @user)    
  end
  
  it "set the session's pending invite code to nil" do
    @session.should_receive(:[]=).with(:pending_invite_code, nil)
    @target.accept_pending_invitations(@session, @user)    
  end
  
  it "returns the name of the project that the invitation was accepted for" do
    result = @target.accept_pending_invitations(@session, @user)    
    result.should == @project.name
  end
end


# 
# describe InvitationManager, ".accept_pending_invitations" do
# end
