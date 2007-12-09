require File.dirname(__FILE__) + '/../spec_helper'

describe Phase do
  it "is a Bucket" do
    Phase.new.should be_kind_of(Bucket)
  end
end