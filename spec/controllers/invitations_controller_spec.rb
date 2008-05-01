require File.dirname(__FILE__) + '/../spec_helper'

describe InvitationsController, "#new" do
  before do
    @project = Generate.project :name => "Project A"
    
    @user = Generate.user :email_address => "user@exmaple.com"
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
