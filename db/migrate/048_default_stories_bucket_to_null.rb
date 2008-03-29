class DefaultStoriesBucketToNull < ActiveRecord::Migration
  class Story < ActiveRecord::Base ; end
  
  def self.up
    change_column :stories, :bucket_id, :integer, :default => nil
    Story.update_all "bucket_id = NULL", "bucket_id = 0"
  end

  def self.down
    change_column :stories, :bucket_id, :integer
  end
end
