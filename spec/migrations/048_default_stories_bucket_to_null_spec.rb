require File.dirname(__FILE__) + '/../spec_helper'

class DefaultStoriesBucketToNullSpec # scopes the redefined model inside this to prevent it from breaking other tests
  class Story < ActiveRecord::Base ; end

  describe "048DefaultStoriesBucketToNull" do
    before(:all) do
      drop_all_tables
      migrate :version => 47
      @stories_with_zeroes = [
        Story.create!(:bucket_id => 0),
        Story.create!(:bucket_id => 0),
        Story.create!(:bucket_id => 0) ]
      @stories_with_nonzeroes = [
        Story.create!(:bucket_id => 1),
        Story.create!(:bucket_id => 2),
        Story.create!(:bucket_id => 3) ]
      migrate :version => 48
    end
  
    after(:all) do
      drop_all_tables
      migrate     
    end

    it "updates all stories which had a bucket_id of 0 to have an nil id" do
      @stories_with_zeroes.each do |story|
        story.reload
        story.bucket_id.should  be_nil
      end
    end
    
    it "doesn't change the bucket_id for stories which did not have a bucket_id of 0" do
      @stories_with_nonzeroes.each_with_index do |story, i|
        story.reload
        story.bucket_id.should == (i+1)
      end
    end
    
    it "makes the bucket_id default to nil for stories" do
      Story.new.bucket_id.should be_nil
      Story.create!.bucket_id.should be_nil
    end
  end
end