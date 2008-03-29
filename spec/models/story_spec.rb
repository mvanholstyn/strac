require File.dirname(__FILE__) + '/../spec_helper'

describe Story do
  before do
    @story = Story.new
  end

  it "should be valid" do
    @story.summary = "story 1"
    @story.project_id = 1
    @story.should be_valid
  end

  it "belongs to a Bucket" do
    assert_association Story, :belongs_to, :bucket, Bucket
  end
  
  it "belongs to a Project" do
    assert_association Story, :belongs_to, :project, Project
  end

  it "belongs to a Status" do
    assert_association Story, :belongs_to, :status, Status
  end  
    
  it "belongs to a Priority" do
    assert_association Story, :belongs_to, :priority, Priority
  end
  
  describe "#responsible_party - polymorphic association" do
    it "associates with another model" do
      @user = Generate.user("some user")
      @project = Generate.project("Some Project")
      @story = Generate.story(:summary => "story summary", :responsible_party => @user)
      @story.responsible_party.should be(@user)
    end
  end
  
  it "should have many Time Entries" do
    assert_association Story, :has_many, :time_entries, TimeEntry, :as => :timeable
  end
  
  it "should have many Comments" do
    assert_association Story, :has_many, :comments, Comment, :as => :commentable
  end
  
  it "should have many Activities" do
    assert_association Story, :has_many, :activities, Activity, :as => :affected 
  end
  
  it "should require a summary" do
    assert_validates_presence_of @story, :summary
  end

  it "should require numeric points" do
    @story.points = "blah"
    assert_validates_numericality_of @story, :points
  end
  
  it "should require numeric position" do
    @story.position = "string"
    assert_validates_numericality_of @story, :position
  end
  
end

# TODO - move Story.reorder to Iteration#reorder
describe Story, ".reorder" do
  def reorder(story_ids, options={})
    Story.reorder(story_ids, options)
  end
 
  before do
    Story.delete_all
    @stories = [ Generate.story, Generate.story, Generate.story ]
  end
  
  it "reorders the stories matching the passed in story ids to be in the same position" do
    reorder([ @stories[2].id, @stories[1].id, @stories[0].id], :bucket_id => 1 )
    @stories.reverse.each_with_index do |story, i|
      story.reload.position.should == i+1
    end
  end

  describe "when given a :bucket_id option" do
    it "moves each story to the passed in :bucket_id option" do
      reorder(@stories, :bucket_id => 2 )
      @stories.each{ |story| story.reload.bucket_id.should == 2 }
      reorder(@stories, :bucket_id => 3 )
      @stories.each{ |story| story.reload.bucket_id.should == 3 }
      reorder(@stories, :bucket_id => nil )
      @stories.each{ |story| story.reload.bucket_id.should == nil }
    end
  end
  
  describe "when a blank entry is given inside the story_ids array" do
    it "ignores it, and does not use it when reordering" do
      reorder(["", @stories.first.id, "", @stories.last.id, "", @stories[1].id], :bucket_id => 99)
      @stories.first.reload.position.should == 1
      @stories.last.reload.position.should == 2
      @stories[1].reload.position.should == 3
    end
  end
end

describe Story, "complete" do
  fixtures :statuses
  
  it "is incomplete if it doesnot have a status" do
    story = Story.new
    story.should be_incomplete
  end
  
  it "is incomplete if its status is defined" do
    story = Story.new :status => statuses(:defined)
    story.should be_incomplete
  end
  
  it "is incomplete if its status is in progress" do
    story = Story.new :status => statuses(:inprogress)
    story.should be_incomplete
  end
  
  it "is complete if its status is complete" do
    story = Story.new :status => statuses(:complete)
    story.should be_complete
  end
  
  it "is complete if its status is rejected" do
    story = Story.new :status => statuses(:rejected)
    story.should be_complete
  end
  
  it "is incomplete if its status is in blocked" do
    story = Story.new :status => statuses(:blocked)
    story.should be_incomplete
  end
end

describe Story, '.find_backlog' do
=begin  def self.find_backlog options = {}
    with_scope :find => options do
      find :all, :conditions => "bucket_id IS NULL"
    end
  end
=end

  before do
    bucket = Generate.bucket
    @stories_without_a_bucket = Generate.stories :count => 2, :bucket => nil
    @stories_with_a_bucket = Generate.stories :count => 2, :bucket => bucket
  end

  it "finds all stories which don't belong to a bucket" do
    Story.find_backlog.should == @stories_without_a_bucket
  end
  
  it "uses the passed in find options to help refine the search while still only including stories without a bucket" do
    @stories_without_a_bucket.first.update_attribute(:description, "BAZ")
    Story.find_backlog(
      :conditions => "description = 'BAZ'"
    ).should == [@stories_without_a_bucket.first]
  end

end