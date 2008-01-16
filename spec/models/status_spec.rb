require File.dirname(__FILE__) + '/../spec_helper'

describe Status do
  before(:each) do
    @status = Status.new
  end

  it "should always have a color" do
    assert_validates_presence_of @status, :color
  end

  it "should be valid" do
    @status.color = "pink"
    @status.should be_valid
  end

end

describe Status, "class methods" do
  fixtures :statuses
  
  it "should have a 'defined' status" do
    Status.defined.should be_an_instance_of(Status)
    Status.defined.name.should == "defined"
  end

  it "should have a 'in progress' status" do
    Status.in_progress.should be_an_instance_of(Status)
    Status.in_progress.name.should == "in progress"
  end

  it "should have a 'complete' status" do
    Status.complete.should be_an_instance_of(Status)
    Status.complete.name.should == "complete"
  end

  it "should have a 'blocked' status" do
    Status.blocked.should be_an_instance_of(Status)
    Status.blocked.name.should == "blocked"
  end

  it "should have a 'rejected' status" do
    Status.rejected.should be_an_instance_of(Status)
    Status.rejected.name.should == "rejected"
  end
end

describe Status, '.statuses' do
  def statuses
    Status.statuses
  end
  
  it "returns an array of the statuses: defined, in progress, complete, blocked and rejected" do
    statuses.should == [ Status.defined, Status.in_progress, Status.complete, Status.rejected, Status.blocked ]
  end
end
