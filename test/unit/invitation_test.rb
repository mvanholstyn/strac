require File.dirname(__FILE__) + '/../test_helper'

class InvitationTest < Test::Unit::TestCase
  
  def setup
    @project = Project.create :id=>1
  end
  
  def teardown
    Project.delete_all
    Invitation.delete_all
  end
  
  def test_belongs_to_inviter
    assert_association Invitation, :belongs_to, :inviter, User, :class_name => "User", :foreign_key => "inviter_id"
  end
  
  def test_belongs_to_project
    assert_association Invitation, :belongs_to, :project, Project
  end  
  
  def test_validates_presence_of_expected_fields
    invitation = Invitation.new
    assert !invitation.valid?
    
    expected_fields = [ :project_id, :inviter_id, :kind ]
    expected_fields.each do |field|
      assert invitation.errors.on( field )
    end
  
    assert_equal expected_fields.size, invitation.errors.size   
  end
  
  def test_build_from_string_with_single_email_address
    invitations = @project.invitations.build_from_string( "user@example.com", :inviter_id => 1, :kind => "customer" )
    assert_equal 1, invitations.size
    assert_equal "user@example.com", invitations.first.recipient
  end
  
  def test_build_from_string_with_multiple_email_addresses
    invitations = @project.invitations.build_from_string( "user@example.com\nuser2@example.com", :inviter_id => 1, :kind => "customer" )
    assert_equal 2, invitations.size
    assert_equal "user@example.com", invitations.first.recipient
    assert_equal "user2@example.com", invitations.last.recipient
  end
  
  def test_build_from_string_with_no_email_addresses
    invitations = @project.invitations.build_from_string( "", :inviter_id => 1, :kind => "customer" )
    assert_equal 0, invitations.size
  end
  
  def test_build_from_string_with_nil_for_email_addresses
    invitations = @project.invitations.build_from_string( nil, :inviter_id => 1, :kind => "customer" )
    assert_equal 0, invitations.size
  end
  
  def test_build_from_string_with_empty_new_lines
    invitations = @project.invitations.build_from_string( "\n\n\n\n", :inviter_id => 1, :kind => "customer" )
    assert_equal 0, invitations.size
  end
end
