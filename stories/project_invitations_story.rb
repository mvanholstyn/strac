require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Invitations", %|
  As a User
  I want to be able to invite other users to a project
  So that they may share in fun and challenging experiences of the project itself.
|, :type => RailsStory do
    
  Scenario "Sending invitations to an existing user of the system" do
    Given "a user is viewing a project" do
      a_user_viewing_a_project
    end
    When "they click on the 'invite people' link" do
      click_on_invite_people_link
    end
    Then "they see an invitation form with text fields for email addresses and message body" do
      see_the_project_invitation_form
    end
    
    Given "the user is viewing an invitation form" do
      # already here
    end
    When "they fill out the form and submit it" do
      submit_the_project_invitation_form
    end
    Then "an email is sent to each email address specified" do
      see_the_emails_were_sent
    end
    And "each email has a accept link" do
      see_the_emails_each_have_a_unique_accept_link
    end
    And "each email contains the body that the user input" do
      see_each_email_contains_the_from_the_submitted_form
    end
  
    Given "an existing user received an email invitation" do
      reset!
    end
    When "they click on the invitation acceptance link" do
      click_invitation_acceptance_link_in_email
    end
    Then "they should be taken to a signup or login page" do
      see_signup_or_login_page
    end
    
    Given "the existing user is viewing the signup or login page" do
      # we are on this page already
    end
    When "they login" do
      login_as @user_accepting_the_project_invitation, "password"
    end
    And "they go to the dashboard page" do
      go_to_the_dashboard
    end
    Then "they see a link which takes them to the project they accepted" do
      see_and_click_on_the_newly_accepted_project_link
    end
  end


  Scenario "Sending invitations to a user not in the system" do
    Given "a user is viewing a project" do
      a_user_viewing_a_project
    end
    When "they click on the 'invite people' link" do
      click_on_invite_people_link
    end
    Then "they see an invitation form with text fields for email addresses and message body" do
      see_the_project_invitation_form
    end
    
    Given "the user is viewing an invitation form" do
      # already here
    end
    When "they fill out the form and submit it" do
      submit_the_project_invitation_form
    end
    Then "an email is sent to each email address specified" do
      see_the_emails_were_sent
    end
    And "each email has a accept link" do
      see_the_emails_each_have_a_unique_accept_link
    end
    And "each email contains the body that the user input" do
      see_each_email_contains_the_from_the_submitted_form
    end

    Given "a user received an email invitation" do
      reset!
    end
    When "they click on the invitation acceptance link" do
      click_invitation_acceptance_link_in_email
    end
    Then "they should be taken to a signup or login page" do
      see_signup_or_login_page
    end
    
    Given "the user is viewing the signup or login page" do
      # we are on this page already
    end
    When "they submit the create an account form with mismatched passwords" do
      submit_signup_form :password => "blah", :password_confirmation => "foo"
    end
    Then "they see the errors regarding the mismatched passwords" do
      see_errors "Password must match".to_regexp
    end

    Given "the user is viewing the signup or login page" do
      # we are on this page already
    end
    When "they submit the create an account form" do
      submit_signup_form
    end
    And "they go to the dashboard page" do
      go_to_the_dashboard
    end
    Then "they see a link which takes them to the project they accepted" do
      see_and_click_on_the_newly_accepted_project_link
    end
  end
  
  def see_and_click_on_the_newly_accepted_project_link
    click_project_link_for @project
  end
  
  def a_user_viewing_a_project
    @project = Generate.project("ProjectA")
    user = Generate.user("joe@blow.com")
    user.projects << @project
    
    get login_path
    login_as user, "password"
    
    click_project_link_for @project
  end
  
  def click_invitation_acceptance_link_in_email
    @user_accepting_the_project_invitation = Generate.user("bob@example.com")
    invitations = Invitation.find(:all)
    get login_url(:code => invitations.first.code)
  end
  
  def see_signup_or_login_page
    response.should have_tag("form#login_form")
  end
  
  def click_on_invite_people_link
    click_link new_project_invitation_path(@project)
  end
  
  def see_the_project_invitation_form
    response.should have_tag("form#new_invitation")
  end
  
  def submit_the_project_invitation_form
    ActionMailer::Base.deliveries.clear
    Invitation.delete_all
    @emails = ["user@example.com", "bob@example.com"]
    @email_body = "Come join my project!"
    
    submit_form "new_invitation" do |form|
      form.email_addresses = @emails.join(",")
      form.email_body = @email_body
    end
  end
  
  def see_the_emails_were_sent
    emails = ActionMailer::Base.deliveries

    emails.size.should == @emails.size
    emails.first.to.should == [@emails.first]
    emails.last.to.should == [@emails.last]
  end
  
  def login_as(user, password)
    submit_form "login_form" do |form|
      form.user.email_address = user.email_address
      form.user.password = password
    end
    follow_redirect!
  end
  
  def see_the_emails_each_have_a_unique_accept_link
    emails = ActionMailer::Base.deliveries
    invitations = Invitation.find(:all)
    emails.first.body.should =~ login_url(:code => invitations.first.code).to_regexp
    emails.last.body.should =~ login_url(:code => invitations.last.code).to_regexp    
  end
  
  def see_each_email_contains_the_from_the_submitted_form
    emails = ActionMailer::Base.deliveries
    emails.first.body.should =~ @email_body.to_regexp
    emails.first.body.should =~ @email_body.to_regexp
  end
  
end