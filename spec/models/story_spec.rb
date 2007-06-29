require File.dirname(__FILE__) + '/../spec_helper'

describe Story do
  before(:each) do
    @story = Story.new
  end

  it "should be valid" do
    @story.summary = "story 1"
    @story.project_id = 1
    @story.should be_valid
  end

  it "should belong to an Iteration" do
    assert_association Story, :belongs_to, :iteration, Iteration
  end
  
  it "should belong to a Project" do
    assert_association Story, :belongs_to, :project, Project
  end

  it "should belong to a Status" do
    assert_association Story, :belongs_to, :status, Status
  end  
    
  it "should belong to a Priority" do
    assert_association Story, :belongs_to, :priority, Priority
  end
  
  it "should belong to a ResponsibleParty (polymorphic)"
  
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
describe "Story class methods" do
  before(:each) do
    @story1 = Story.create!(:summary=>"Story1", :project_id=>2, :iteration_id=>1)
    @story2 = Story.create!(:summary=>"Story2", :project_id=>2, :iteration_id=>1)
  end
  
  it "should reorder Stories" do
    @story1.position.should == 1
    @story2.position.should == 2
    Story.reorder( [@story2.id, @story1.id] )
    @story1.reload.position.should == 2
    @story2.reload.position.should == 1    
  end

end