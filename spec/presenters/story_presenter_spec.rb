require File.dirname(__FILE__) + '/../spec_helper'

describe StoryPresenter do
  
  before do
    @story = mock_model(Story)
    @presenter = StoryPresenter.new(:story => @story)
  end
  
  describe "delegations" do
    it_delegates :class, :errors, :id, :new_record?, :to_param,
      :bucket, :bucket_id, :comments, :description, :errors, :points,
      :priority_id, :project, :project_id, :responsible_party, :responsible_party_type_id,
      :status, :status_id, :summary, :tag_list,
      :on => :presenter, :to => :story
  end
  
  it "has possible buckets which are grouped by type" do
    buckets = [ 
      mock_model(Bucket, :type => "bucket"),
      mock_model(Bucket, :type => "banana"),
      mock_model(Bucket, :type => "bucket"),
      mock_model(Bucket, :type => "banana") ]
    project = mock_model(Project)
    @story.stub!(:project).and_return(project)
    project.stub!(:buckets).and_return(buckets)
    @presenter.possible_buckets.should == [
      OpenStruct.new(:name => "bucket", :group => [ buckets[0], buckets[2] ]),
      OpenStruct.new(:name => "banana", :group => [ buckets[1], buckets[3] ])
    ]
  end
  
  it "has possible statuses" do
    Status.should_receive(:all).and_return("statuses")
    @presenter.possible_statuses.should == "statuses"
  end
  
  it "has possible priorities" do
    Priority.should_receive(:all).and_return("priorities")
    @presenter.possible_priorities.should == "priorities"    
  end
  
end
