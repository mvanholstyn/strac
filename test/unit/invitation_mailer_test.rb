require File.dirname(__FILE__) + '/../test_helper'

class InvitationMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures/units/invitation_mailer'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end
  
  def test_invite_developer
    invitation = Invitation.new :recipient=>"zach.dennis@gmail.com", :kind=>"developer", :project_id=>1, :inviter_id=>1
    
    inviter = mock
    inviter.expects( :email_address ).returns( "zach.dennis@gmail.com" )
    inviter.expects( :full_name ).returns( "Zach Dennis" )
    invitation.expects( :inviter ).returns( inviter ).times(2)
    
    project = mock
    project.expects( :name ).returns( "Strac" ).times(2)
    invitation.expects( :project ).returns( project ).times(2)
    
    response = InvitationMailer.create_invite_developer( invitation )
    assert_equal "You've been invited as a developer to 'Strac'!", response.subject
    assert_equal "You've been invited as a developer to 'Strac'!", response.body
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
