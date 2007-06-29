require File.dirname(__FILE__) + '/../spec_helper'

describe Priority do
  before(:each) do
    @priority = Priority.new
  end

  it "should be valid" do
    @priority.should be_valid
  end
end
