class AddCompletedAtToStories < ActiveRecord::Migration
  
  class Story < ActiveRecord::Base; end
  class Status < ActiveRecord::Base ; end
  
  def self.up
    add_column :stories, :completed_at, :datetime
    
    status = Status.find_by_name("complete")
    curdate = Time.now.to_s(:db)
    Story.update_all "completed_at = '#{curdate}'", "status_id=#{status.id}"
  end

  def self.down
    remove_column :stories, :completed_at
  end
end
