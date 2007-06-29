class AddCompletedAtToStories < ActiveRecord::Migration
  
  class Story < ActiveRecord::Base; end
  class Status < ActiveRecord::Base ; end
  
  def self.up
    add_column :stories, :completed_at, :datetime
    
    status = Status.find_by_name("complete")
    Story.update_all "completed_at = CURDATE()", "status_id=#{status.id}"
  end

  def self.down
    remove_column :stories, :completed_at
  end
end
