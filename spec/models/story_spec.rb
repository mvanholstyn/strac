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
      @story = Generate.story("story summary", :responsible_party => @user)
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
describe "Reordering stories" do
  before(:each) do
    @story1 = Story.create!(:summary=>"Story1", :project_id=>2, :bucket_id=>1)
    @story2 = Story.create!(:summary=>"Story2", :project_id=>2, :bucket_id=>1)
        
    @story1.position.should == 1 ; @story1.bucket_id.should == 1
    @story2.position.should == 2 ; @story2.bucket_id.should == 1
  end
  
  it "should require an iteration id" do
    lambda {
      Story.reorder( [@story2.id], {})
    }.should raise_error(ArgumentError)
  end
  
  it "should update story positions" do
    Story.reorder( [@story2.id, @story1.id], :bucket_id=>1 )
    @story1.reload.position.should == 2
    @story2.reload.position.should == 1    
  end

  it "should set the story's iteration when the updated story iteration is not nil" do
    Story.reorder( [@story2.id ], :bucket_id => 2 )
    @story1.reload.bucket_id.should == 1
    @story2.reload.bucket_id.should == 2
  end
  
  it "should set the Story's iteration to nil when the updated story iteration is nil" do
    Story.reorder( [@story2.id ], :bucket_id => nil )
    @story1.reload.bucket_id.should == 1
    @story2.reload.bucket_id.should == nil
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