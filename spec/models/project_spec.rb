require File.dirname(__FILE__) + '/../spec_helper'

describe Project do
  before(:each) do
    @project = Project.new
  end

  it "should be valid" do
    @project.should be_valid
  end

  it "should have many invitations" do
    assert_association Project, :has_many, :invitations, Invitation
  end

end
