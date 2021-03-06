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
  
  describe "#responsible_party - polymorphic association" do
    it "associates with another model" do
      @user = Generate.user(:email_address => "some user")
      @project = Generate.project(:name => "Some Project")
      @story = Generate.story(:summary => "story summary", :responsible_party => @user)
      @story.responsible_party.should be(@user)
    end
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
  
  describe "when no :bucket_id option is supplied" do
    it "does not change the story's bucket" do
      @stories.each { |story| story.update_attribute(:bucket_id, 99) }
      reorder(@stories)
      @stories.each{ |story| story.reload.bucket_id.should == 99 }    
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

describe Story, "when a story is completed" do
  before do
    @story = Generate.story
    @project = @story.project
  end
  
  describe "when there is a current iteration for the story's project" do
    it "assigns the story to the currently running iteration" do
      iteration = Generate.iteration :project => @project, :started_at => Date.yesterday, :ended_at => nil      
      @story.bucket.should be_nil
      @story.status = Status.complete
      @story.save!
      @story.bucket.should == iteration
    end
  end

  describe "when the story belongs to a non-iteration bucket and the story is completed" do
    it "assigns the story to the currently running iteration" do
      iteration = Generate.iteration :project => @project, :started_at => Date.yesterday, :ended_at => nil
      bucket = Generate.bucket
      @story.update_attribute :bucket, bucket
      @story.bucket.should == bucket
      @story.status = Status.complete
      @story.save!
      @story.bucket.should == iteration      
    end
  end

end