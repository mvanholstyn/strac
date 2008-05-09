require File.dirname(__FILE__) + '/../spec_helper'

describe Bucket do
  
  before do
    @bucket = Bucket.new
  end

  describe "associations" do
    it_belongs_to :project
    it_has_many :stories, :order => :position, :dependent => :nullify
    it_has_one :snapshot, :dependent => :destroy
  end
  
  it "should always belong to a project" do
    assert_validates_presence_of @bucket, :project_id
  end
  
  it "should always have a name" do
    assert_validates_presence_of @bucket, :name
  end
  
end

describe Bucket, '#completed_stories' do
  def completed_stories
    @bucket.completed_stories
  end
  
  before do
    @bucket = Generate.bucket
    @completed_stories = [
      Generate.story(:status => Status.complete),
      Generate.story(:status => Status.complete) ]
    @bucket.stories << @completed_stories
    @completed_stories.first.update_attribute(:position, 2)
    @completed_stories.last.update_attribute(:position, 1)
    @completed_stories_in_order = [@completed_stories.last, @completed_stories.first]
  end

  it "returns stories which are complete ordered by position" do
    completed_stories.should == @completed_stories_in_order
  end
  
  describe "when there are completed stories in other buckets" do
    before do
      @other_bucket = Generate.bucket
      @other_bucket.stories << Generate.story(:status => Status.complete)
      @other_bucket.stories << Generate.story(:status => Status.complete)
    end

    it "only returns the completed stories" do
      completed_stories.should == @completed_stories_in_order
    end
  end

  describe "when the bucket is associated with non-complete stories" do
    before do
      Status.statuses.each do |status|
        next if status == Status.complete
        @bucket.stories << Generate.story(:status => status)
      end
    end
    
    it "only returns the completed stories" do
      completed_stories.should == @completed_stories_in_order
    end
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
