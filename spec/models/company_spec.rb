require File.dirname(__FILE__) + '/../spec_helper'

describe Company do
  before(:each) do
    @company = Company.new
  end

  it "should be valid" do
    @company.should be_valid
  end
end
