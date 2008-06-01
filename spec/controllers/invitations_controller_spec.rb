require File.dirname(__FILE__) + '/../spec_helper'

describe InvitationsController, "#new" do
  before do
    @project = Generate.project :name => "Project A"
    
    @user = Generate.user :email_address => "user@example.com"
    @user.projects << @project
    
    @invitation = stub("Invitation")
    Invitation.stub!(:new)
    
    login_as @user
  end

  def get_new
    get :new, :project_id => @project.id
  end

  it "is successful" do
    get_new
    response.should be_success
  end
  
  it "renders the new tmplate" do
    get_new
    response.should render_template('new')
  end

  it "assigns a new invitation" do
    get_new
    assigns[:project].should == @project
  end

  it "assigns a new invitation" do
    Invitation.should_receive(:new).and_return(@invitation)
    
    get_new
    
    assigns[:invitation].should == @invitation
  end
end

describe InvitationsController, "#create" do
  def post_create
    post :create, :project_id => @project.id, :email_addresses => @emails.join(","), :email_body => @email_body
  end
  
  before do
    @project = mock_model(Project)
    @user = Generate.user :email_address => "user@exmaple.com"
    @user.projects << @project
    login_as @user

    @email_body = "Body-O"
    @emails = ["user@example.com", "bob@example.com"]
    @invitations = [ mock("invitation 1"), mock("invitation 2") ].map do |invitation|
      invitation.stub!(:accept_invitation_url=)
      invitation.stub!(:code)
    end

    Project.stub!(:find).and_return(@project)
    Invitation.stub!(:create_for).and_return([])
    InvitationMailer.stub!(:deliver_invitation)
  end
  
  it "redirects to the project dashboard" do
    post_create
    response.should redirect_to(project_path(@project))
  end

  it "creates and sends an invitation with an accept_invitation_url for each email address" do
    Invitation.should_receive(:create_for).with(@project, @user, @emails.join(","), @email_body).and_return(@invitations)

    code1 = stub("invitation code 1")
    code2 = stub("invitation code 2")
    @invitations.first.should_receive(:code).and_return(code1)
    @invitations.first.should_receive(:accept_invitation_url=)
    @invitations.last.should_receive(:code).and_return(code2)
    @invitations.last.should_receive(:accept_invitation_url=)

    InvitationMailer.should_receive(:deliver_invitation).with(@invitations.first)
    InvitationMailer.should_receive(:deliver_invitation).with(@invitations.last)

    post_create
  end
end
