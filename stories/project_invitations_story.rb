require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Invitations", %|
  As a User
  I want to be able to invite other users to a project
  So that they may share in fun and challenging experiences of the project itself.
|, :type => RailsStory do
  
  Scenario "Sending invitations" do
    Given "a user is viewing a project" do
      a_user_viewing_a_project
    end
    When "they click on the 'Invite People' link" do
      click_on_invite_people_link
    end
    Then "they see an invitation form with text fields for email addresses and message body" do
      see_the_project_invitation_form
    end
    
    Given "a user is viewing an invitation form" do; end
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
    
  end

  def a_user_viewing_a_project
    @project = Generate.project("ProjectA")
    user = Generate.user("joe@blow.com")
    user.projects << @project
    
    get login_path
    login_as user, "password"
    
    click_project_link_for @project
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
  
  
  def click_project_link_for(project)
    click_link project_path(project)
  end

end