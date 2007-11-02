require File.dirname(__FILE__) + '/../spec_helper'


describe UsersController, "#login - get request" do
  def get_login(params={}) 
    get :login, {}.merge(params)
  end
  
  setup do
    InvitationManager.stub!(:store_pending_invitation_acceptance)
  end
  
  it "stores a pending invitation for whatever invitation code is passed in" do
    InvitationManager.
      should_receive(:store_pending_invitation_acceptance).
      with(controller.session, "abc1234")
    get_login :code => "abc1234"
  end

  it "renders the login template" do
    get_login
    response.should render_template("login")
  end
end

describe UsersController, "#login - post request without a successful user login" do
  it "does nothing" do
    InvitationManager.should_not_receive(:accept_pending_invitations)
    post :login, :user => {:email_address => "foo", :password => "bad password"}
  end
end
 
describe UsersController, "#login - post request with a successful user login" do
  def post_login(params={})
    post :login, :user => {:email_address => @user.email_address, :password => "password"}.merge(params)
  end
  
  before do
    @user = Generate.user("bob@example.com")
    InvitationManager.stub!(:accept_pending_invitations)
  end
  
  it "accepts any pending invitations" do
    InvitationManager.
      should_receive(:accept_pending_invitations).
      with(controller.session, @user)
    post_login
  end
  
  it "sets the flash[:notice] to a message when an invitation is accepted" do
    InvitationManager.stub!(:accept_pending_invitations).and_return("ProjectFoo")    
    post_login
    flash[:notice].should == "You have been added to project: ProjectFoo"
  end

  it "doesn't the flash[:notice] to a message when an invitation is not accepted" do
    InvitationManager.stub!(:accept_pending_invitations).and_return(nil)        
    post_login
    flash[:notice].should be_nil
  end

  it "redirects to the dashboard path" do
    post_login
    response.should redirect_to(dashboard_path)
  end
end
