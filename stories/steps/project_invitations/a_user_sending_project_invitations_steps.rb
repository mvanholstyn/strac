steps_for :a_user_sending_project_invitations do
  Given "a user is viewing a project" do
    a_user_viewing_a_project
  end
  Given "the user is viewing an invitation form" do
    see_the_project_invitation_form
  end
  Given /a(n existing)? user received an email invitation/ do
    reset!
  end
  Given /the (existing )?user is viewing the signup or login page/ do
    see_signup_or_login_page
  end


  When "they click on the 'invite people' link" do
    click_on_invite_people_link(@project)
  end
  When "they fill out the invitation form and submit it" do
    ActionMailer::Base.deliveries.clear
    Invitation.delete_all
    @emails = ["user@example.com", "bob@example.com"]
    @email_body = "Come join my project!"
    
    submit_new_invitation_form do |form|
      form.email_addresses = @emails.join(",")
      form.email_body = @email_body
    end
  end
  When "they login" do
    login_as @user_accepting_the_project_invitation.email_address, "password"
  end
  When "they go to the dashboard page" do
    go_to_the_dashboard
  end
  When "they click on the invitation acceptance link" do
    @user_accepting_the_project_invitation = Generate.user(:email_address => "bob@example.com")
    invitations = Invitation.find(:all)
    get login_url(:code => invitations.first.code)
  end
  When "they submit the create an account form with mismatched passwords" do
    submit_signup_form :password => "blah", :password_confirmation => "foo"
  end
  When "they submit the create an account form" do
    submit_signup_form
  end


  Then "they see an invitation form with text fields for email addresses and message body" do
    see_the_project_invitation_form
  end  
  Then "an email is sent to each email address specified" do
    emails = ActionMailer::Base.deliveries
    emails.size.should == @emails.size
    emails.first.to.should == [@emails.first]
    emails.last.to.should == [@emails.last]
  end
  Then "each email has an accept link" do
    emails = ActionMailer::Base.deliveries
    invitations = Invitation.find(:all)
    emails.first.body.should =~ login_url(:code => invitations.first.code).to_regexp
    emails.last.body.should =~ login_url(:code => invitations.last.code).to_regexp    
  end
  Then "each email contains the body that the user input" do
    emails = ActionMailer::Base.deliveries
    emails.first.body.should =~ @email_body.to_regexp
    emails.last.body.should =~ @email_body.to_regexp
  end
  Then "they are taken to a signup or login page" do
    see_signup_or_login_page
  end
  Then "they see a link which takes them to the project they accepted" do
    click_project_link_for @project
  end
  Then "they see the errors regarding the mismatched passwords" do
    see_errors "Password must match".to_regexp
  end

end