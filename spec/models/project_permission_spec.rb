require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectPermission do
  before(:each) do
    @project_permission = ProjectPermission.new
  end

  it "should be valid" do
    @project_permission.should be_valid
  end
end
