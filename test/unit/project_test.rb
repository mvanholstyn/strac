require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < Test::Unit::TestCase
  fixtures :projects

  def test_has_many_invitations
    assert_association Project, :has_many, :invitations, Invitation
  end
end
