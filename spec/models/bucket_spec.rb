require File.dirname(__FILE__) + '/../spec_helper'

describe Bucket do
  
  before do
    @bucket = Bucket.new
  end
  
  it "has many stories ordered by position" do
    assert_association Bucket, :has_many, :stories, Story, :order => :position
  end
  
  it "should always belong to a project" do
    assert_validates_presence_of @bucket, :project_id
  end
  
  it "should always have a name" do
    assert_validates_presence_of @bucket, :name
  end
  
end

describe Bucket, '#display_name' do
  before do
    @bucket = Bucket.new :name => "foo"
  end
  
  it "returns the bucket's name" do
    @bucket.display_name.should == @bucket.name
  end
end
