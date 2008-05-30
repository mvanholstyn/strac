require File.dirname(__FILE__) + '/../spec_helper'

# describe UsersController, "#login - get request" do
#   def get_login(params={}) 
#     get :login, {}.merge(params)
#   end
#   
#   setup do
#     InvitationManager.stub!(:store_pending_invitation_acceptance)
#   end
#   
#   it "stores a pending invitation for whatever invitation code is passed in" do
#     InvitationManager.
#       should_receive(:store_pending_invitation_acceptance).
#       with(controller.session, "abc1234")
#     get_login :code => "abc1234"
#   end
# 
#   it "renders the login template" do
#     get_login
#     response.should render_template("login")
#   end
# end
# 
# describe UsersController, "#login - post request without a successful user login" do
#   it "does nothing" do
#     InvitationManager.should_not_receive(:accept_pending_invitations)
#     post :login, :user => {:email_address => "foo", :password => "bad password"}
#   end
# end
#  
# describe UsersController, "#login - post request with a successful user login" do
#   def post_login(params={})
#     post :login, :user => {:email_address => @user.email_address, :password => "password"}.merge(params)
#   end
#   
#   before do
#     @user = Generate.user(:email_address => "bob@example.com")
#     InvitationManager.stub!(:accept_pending_invitations)
#   end
#   
#   it "accepts any pending invitations" do
#     InvitationManager.
#       should_receive(:accept_pending_invitations).
#       with(controller.session, @user)
#     post_login
#   end
#   
#   it "sets the flash[:notice] to a message when an invitation is accepted" do
#     InvitationManager.stub!(:accept_pending_invitations).and_return("ProjectFoo")    
#     post_login
#     flash[:notice].should == "You have been added to project: ProjectFoo"
#   end
# 
#   it "doesn't the flash[:notice] to a message when an invitation is not accepted" do
#     InvitationManager.stub!(:accept_pending_invitations).and_return(nil)        
#     post_login
#     flash[:notice].should be_nil
#   end
# 
#   it "redirects to the dashboard path" do
#     post_login
#     response.should redirect_to(dashboard_path)
#   end
# end
# 

describe UsersController, "#signup - post request with a successful user signup" do
  def post_signup(params={})
    post :signup, :user => {
        :email_address => "some email addy", 
        :password => "password",
        :password_confirmation => "password"
      }.merge(params)
  end
  
  before do
    @user = mock_model(User, :save => true, :active= => false)
    User.stub!(:new).and_return(@user)
    
    @reminder = mock_model(UserReminder, :token => nil)
    UserReminder.stub!(:create_for_user).and_return(@reminder)
    
    UserReminderMailer.stub!(:deliver_signup)
    
    InvitationManager.stub!(:accept_pending_invitations)
    @group = stub("some group", :id => 99)
    Group.stub!(:find_by_name).with("Developer").and_return(@group)
  end
  
  it "redirects to the dashboard path" do
    post_signup
    response.should redirect_to(dashboard_path)
  end  
  
  it "assigns the default group to the user" do
    Group.should_receive(:find_by_name).with("Developer").and_return(@group)
    post_signup
    params[:user][:group_id].should == @group.id
  end
  
  it "accepts any pending invitations" do
    InvitationManager.
      should_receive(:accept_pending_invitations).
      with(controller.session, @user)
    post_signup
  end
  
  it "sets the flash[:notice] to a message when an invitation is accepted" do
    InvitationManager.stub!(:accept_pending_invitations).and_return("ProjectFoo")    
    post_signup
    flash[:notice].should == "You have been added to project: ProjectFoo"
  end

  it "doesn't the flash[:notice] to a message when an invitation is not accepted" do
    InvitationManager.stub!(:accept_pending_invitations).and_return(nil)        
    post_signup
    flash[:notice].should == "You have successfully signed up"
  end

  it "sets the current user" do
    post_signup
    controller.current_user.should == @user
  end
end


describe UsersController, "#signup - post request which fails user signup" do
  def post_signup(params={})
    post :signup, :user => {
        :email_address => "some email addy", 
        :password => "password",
        :password_confirmation => "password"
      }.merge(params)
  end
  
  before do
    @user = mock_model(User, :save => false, :active= => false)
    User.stub!(:new).and_return(@user)

    @group = stub("some group", :id => 99)
    Group.stub!(:find_by_name).with("Developer").and_return(@group)
  end
    
  it "doesn't the flash[:notice] to a message when an invitation is not accepted" do
    post_signup
    flash[:notice].should be_nil
  end

  it "redirects to the dashboard path" do
    post_signup
    response.should render_template("users/signup")
  end

  it "doesn't set the current user" do
    post_signup
    controller.current_user.should be_nil
  end
end


