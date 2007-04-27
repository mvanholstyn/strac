require File.dirname(__FILE__) + '/../test_helper'
require 'invitations_controller'

# Re-raise errors caught by the controller.
class InvitationsController; def rescue_action(e) raise e end; end

class InvitationsControllerTest < Test::Unit::TestCase
  fixtures :all
  
  def setup
    @controller = InvitationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @emails = ActionMailer::Base.deliveries
    @emails.clear
    
    login_as 'zdennis'
  end
  
  def test_new
    get :new, :project_id => 1
    assert_response :success
    assert_template 'new'
    assert assigns(:invitation)
    assert assigns(:project)
  end
  
  def test_create_an_invitation_fails_saving
    project = Project.create :id=>1, :name=>"strac"
    Project.expects(:find).returns(project).times(2)
    
    project_invitations = mock
    invitation = Invitation.new( :inviter_id => User.current_user.id, :recipient => "mvette13@gmail.com", :project_id => 1, :kind => "developer") 
    project_invitations.expects( :build_from_string ).
      with('mvette13@gmail.com', :kind=>"developer", :inviter_id=>User.current_user.id).
      returns( [ invitation ] )      
        
    project.expects(:invitations).returns(project_invitations)
    invitation.expects(:save!).raises( ActiveRecord::RecordNotSaved, "")
    
    post :create, :invitation=>{ :developers=>"mvette13@gmail.com", :customers=>"zach.dennis@gmail.com" }, :project_id=>1
    assert_redirected_to new_invitation_path(project)
    assert_equal "Your invitations were unable to be sent!", flash[:error]
  end

  def test_create_an_invitation_for_one_person_in_each_group
    project = Project.new :id=>1, :name=>"strac"
    project.expects(:to_param).returns('1').times(2)
    Project.expects(:find).returns(project).times(3)
        
    project_invitations = mock
    project_invitations.expects( :build_from_string ).with('mvette13@gmail.com', :kind=>"developer", :inviter_id=>User.current_user.id).returns( 
      [Invitation.new( :inviter_id => User.current_user.id, :recipient => "mvette13@gmail.com", :project_id => 1, :kind => "developer") ]
    )
    project_invitations.expects( :build_from_string ).with('zach.dennis@gmail.com', :kind=>"customer", :inviter_id=>User.current_user.id).returns( 
      [Invitation.new( :inviter_id => User.current_user.id, :recipient => "zach.dennis@gmail.com", :project_id => 1, :kind => "customer" )]
    )
 
    project.expects(:invitations).returns(project_invitations).times(2)
    
    post :create, :invitation=>{ :developers=>"mvette13@gmail.com", :customers=>"zach.dennis@gmail.com" }, :project_id=>1
    assert_redirected_to project_path(project)
    assert_equal 2, @emails.size, "Two emails should have been sent!"
    
    developer_email = @emails.shift
    assert_equal "You've been invited as a developer to '#{project.name}'!",  developer_email.subject, "wrong subject!"
    assert_match /You've been invited as a developer to '#{project.name}'!/, developer_email.body, "wrong body!"
    
    customer_email = @emails.shift
    assert_equal "You've been invited as a customer to '#{project.name}'!",  customer_email.subject, "wrong subject!"
    assert_match /You've been invited as a customer to '#{project.name}'!/, customer_email.body, "wrong body!"
    
    assert_equal "Your invitations have been sent!", flash[:notice]
  end
  
  def test_create_an_invitiation_for_multiple_persons_in_each_group
    project = Project.new :id=>1, :name=>"strac"
    project.expects(:to_param).returns('1').times(2)
    Project.expects(:find).returns(project).times(5)
        
    project_invitations = mock
    project_invitations.expects( :build_from_string ).with("mvette13@gmail.com\njack@gmail.com", :kind=>"developer", :inviter_id=>User.current_user.id).returns( 
      [ Invitation.new( :inviter_id => User.current_user.id, :recipient => "mvette13@gmail.com", :project_id => 1, :kind => "developer"),
        Invitation.new( :inviter_id => User.current_user.id, :recipient => "jack@gmail.com", :project_id => 1, :kind => "developer") ]
    )
    project_invitations.expects( :build_from_string ).with("zach.dennis@gmail.com\nbob@gmail.com", :kind=>"customer", :inviter_id=>User.current_user.id).returns( 
      [ Invitation.new( :inviter_id => User.current_user.id, :recipient => "zach.dennis@gmail.com", :project_id => 1, :kind => "customer" ), 
        Invitation.new( :inviter_id => User.current_user.id, :recipient => "bob@gmail.com", :project_id => 1, :kind => "customer" ) ]
    )
 
    project.expects(:invitations).returns(project_invitations).times(4)
    
    post :create, :invitation=>{ :developers=>"mvette13@gmail.com\njack@gmail.com", :customers=>"zach.dennis@gmail.com\nbob@gmail.com" }, :project_id=>1
    assert_redirected_to project_path(project)
    assert_equal 4, @emails.size, "Four emails should have been sent!"
    
    developer_email = @emails.shift
    assert_equal "You've been invited as a developer to '#{project.name}'!",  developer_email.subject, "wrong subject!"
    assert_match /You've been invited as a developer to '#{project.name}'!/, developer_email.body, "wrong body!"
    
    developer_email = @emails.shift
    assert_equal "You've been invited as a developer to '#{project.name}'!",  developer_email.subject, "wrong subject!"
    assert_match /You've been invited as a developer to '#{project.name}'!/, developer_email.body, "wrong body!"
    
    customer_email = @emails.shift
    assert_equal "You've been invited as a customer to '#{project.name}'!",  customer_email.subject, "wrong subject!"
    assert_match /You've been invited as a customer to '#{project.name}'!/, customer_email.body, "wrong body!"
    
    customer_email = @emails.shift
    assert_equal "You've been invited as a customer to '#{project.name}'!",  customer_email.subject, "wrong subject!"
    assert_match /You've been invited as a customer to '#{project.name}'!/, customer_email.body, "wrong body!"

    assert_equal "Your invitations have been sent!", flash[:notice]    
  end
  
  def test_create_an_invitiation_for_people_in_the_developers_group_but_not_the_customers
    project = Project.new :id=>1, :name=>"strac"
    project.expects(:to_param).returns('1').times(2)
    Project.expects(:find).returns(project).times(3)
        
    project_invitations = mock
    project_invitations.expects( :build_from_string ).with("mvette13@gmail.com\njack@gmail.com", :kind=>"developer", :inviter_id=>User.current_user.id).returns( 
      [ Invitation.new( :inviter_id => User.current_user.id, :recipient => "mvette13@gmail.com", :project_id => 1, :kind => "developer"),
        Invitation.new( :inviter_id => User.current_user.id, :recipient => "jack@gmail.com", :project_id => 1, :kind => "developer") ]
    )
    project_invitations.expects( :build_from_string ).with("", :kind=>"customer", :inviter_id=>User.current_user.id).returns( [] )
 
    project.expects(:invitations).returns(project_invitations).times(2)
    
    post :create, :invitation=>{ :developers=>"mvette13@gmail.com\njack@gmail.com", :customers=>"" }, :project_id=>1
    assert_redirected_to project_path(project)
    assert_equal 2, @emails.size, "Two emails should have been sent!"
    
    developer_email = @emails.shift
    assert_equal "You've been invited as a developer to '#{project.name}'!",  developer_email.subject, "wrong subject!"
    assert_match /You've been invited as a developer to '#{project.name}'!/, developer_email.body, "wrong body!"
    
    developer_email = @emails.shift
    assert_equal "You've been invited as a developer to '#{project.name}'!",  developer_email.subject, "wrong subject!"
    assert_match /You've been invited as a developer to '#{project.name}'!/, developer_email.body, "wrong body" 

    assert_equal "Your invitations have been sent!", flash[:notice]   
  end
  
  def test_create_an_invitiation_for_people_in_the_customers_group_but_not_the_developers
    project = Project.new :id=>1, :name=>"strac"
    project.expects(:to_param).returns('1').times(2)
    Project.expects(:find).returns(project).times(3)
        
    project_invitations = mock
    project_invitations.expects( :build_from_string ).with("", :kind=>"developer", :inviter_id=>User.current_user.id ).returns( [] )
    project_invitations.expects( :build_from_string ).with("zach.dennis@gmail.com\nbob@gmail.com", :kind=>"customer", :inviter_id=>User.current_user.id).returns( 
      [ Invitation.new( :inviter_id => User.current_user.id, :recipient => "zach.dennis@gmail.com", :project_id => 1, :kind => "customer" ), 
        Invitation.new( :inviter_id => User.current_user.id, :recipient => "bob@gmail.com", :project_id => 1, :kind => "customer" ) ]
    )
 
    project.expects(:invitations).returns(project_invitations).times(2)
    
    post :create, :invitation=>{ :developers=>"", :customers=>"zach.dennis@gmail.com\nbob@gmail.com" }, :project_id=>1
    assert_redirected_to project_path(project)
    assert_equal 2, @emails.size, "Two emails should have been sent!"
    
    customer_email = @emails.shift
    assert_equal "You've been invited as a customer to '#{project.name}'!",  customer_email.subject, "wrong subject!"
    assert_match /You've been invited as a customer to '#{project.name}'!/, customer_email.body, "wrong body!"
    
    customer_email = @emails.shift
    assert_equal "You've been invited as a customer to '#{project.name}'!",  customer_email.subject, "wrong subject!"
    assert_match /You've been invited as a customer to '#{project.name}'!/, customer_email.body, "wrong body"
    
    assert_equal "Your invitations have been sent!", flash[:notice]    
  end
  
end
