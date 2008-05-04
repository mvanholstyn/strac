require File.dirname(__FILE__) + '/../spec_helper'

# describe UsersController, "#login - get request" do
#   def get_login(params={}) 
#     get :login, {}.merge(params)
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
  def post_signup(params={}, session={})
    post :signup, { :user => {
        :email_address => "some email addy", 
        :password => "password",
        :password_confirmation => "password"
      }.merge(params) }, session
  end
  
  before do
    @user = mock_model(User, :save => true, :active= => false)
    User.stub!(:new).and_return(@user)
    
    @reminder = mock_model(UserReminder, :token => nil)
    UserReminder.stub!(:create_for_user).and_return(@reminder)
    UserReminderMailer.stub!(:deliver_signup)

    Invitation.stub!(:find_by_code)
    Project.stub!(:find)

    @group = stub("some group", :id => 99)
    Group.stub!(:find_by_name).with("Developer").and_return(@group)
    
    @project = mock_model(Project, :name => "ProjectFoo")
    @invitation = mock_model(Invitation, :project_id => @project.id)
  end
  
  it "assigns the default group to the user" do
    Group.should_receive(:find_by_name).with("Developer").and_return(@group)
    post_signup
    params[:user][:group_id].should == @group.id
  end
  
  it "accepts any pending invitations for the current user" do
    projects = []
    Invitation.should_receive(:find_by_code).with("ABC123").and_return(@invitation)
    Project.should_receive(:find).with(@invitation.project_id).and_return(@project)
    @user.stub!(:projects).and_return(projects)
    post_signup({}, {:pending_invite_code => "ABC123"})
    projects.should == [@project]
  end

  describe "when an invitation is accepted" do
    before do
      Invitation.stub!(:find_by_code).and_return(@invitation)
      Project.stub!(:find).and_return(@project)
      @user.stub!(:projects).and_return([])
    end
    
    it "sets the flash[:notice] message telling the user they have been added to the project for the invitation" do
      post_signup({}, {:pending_invite_code => "ABC123"})
      flash[:notice].should == "You have been added to project: ProjectFoo"
    end
  end

  describe "when an invitation is not accepted" do
    it "sets the flash[:notice] message telling the user they have successfully signed up" do
      post_signup({}, {:pending_invite_code => nil})
      flash[:notice].should == "You have successfully signed up"
    end
  end

  it "redirects to the dashboard path" do
    post_signup
    response.should redirect_to(dashboard_path)
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
    
  it "doesn't set the flash[:notice] message" do
    post_signup
    flash[:notice].should be_nil
  end

  it "renders the users/signup template" do
    post_signup
    response.should render_template("users/signup")
  end

  it "doesn't set the current user" do
    post_signup
    controller.current_user.should be_nil
  end
end


