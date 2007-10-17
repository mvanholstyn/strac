require File.dirname(__FILE__) + '/../spec_helper'

describe InvitationMailer, "#create_invitation" do
  include ActionController::UrlWriter

  def create_invitation_email
    @email = InvitationMailer.create_invitation(@invitation)    
  end
  
  before do
    @invitation = Generate.invitation("joe@foo.com")
  end
  
  it "sends the email to invitation's recipient" do
    create_invitation_email
    @email.to.should == [@invitation.recipient]
  end
  
  it "sends the email from the inviter" do
    create_invitation_email
    @email.from.should == [@invitation.inviter.email_address]
  end
  
  it "has a subject from the project" do
    create_invitation_email
    @email.subject.should == "You've been invited to '#{@invitation.project.name}'!"
  end
  
  it "contains the invitation message in the email body" do
    create_invitation_email
    @email.body.should match(@invitation.message.to_regexp)
  end
  
  it "contains the the project's name for which the invitation was sent" do
    create_invitation_email
    @email.body.should match(@invitation.project.name.to_regexp)
  end

  it "contains a link to accept the invitation" do
    @invitation.accept_invitation_url = "http://some link for email acceptance"
    create_invitation_email
    @email.body.should match(@invitation.accept_invitation_url.to_regexp)
  end

end

describe InvitationMailer, "#deliver_invitation" do
  def deliver_invitation_email
    InvitationMailer.deliver_invitation(@invitation)        
  end
  
  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @invitation = Generate.invitation("joe@foo.com")
    @invitation.accept_invitation_url = "some invitation url"
  end

  it "sends the email" do
    deliver_invitation_email
    ActionMailer::Base.deliveries.size.should == 1
  end

end