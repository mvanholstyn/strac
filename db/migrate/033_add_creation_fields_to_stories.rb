class AddCreationFieldsToStories < ActiveRecord::Migration
  class Story < ActiveRecord::Base ; end
  class Iteration < ActiveRecord::Base
    has_many :stories
  end
  
  def self.up
    add_column :stories, :created_at, :datetime
    
    # update each story before this migration to have a creation date which matches the start
    # date of its iteration
    Iteration.find(:all).each do |iteration|
      iteration.stories.update_all "created_at=DATE('#{iteration.start_date.to_s(:db)}')"
    end

    # update all backlog stories to have a creation date of today
    now = Time.now.to_s(:db)
    Story.update_all "created_at='#{now}'", "created_at IS NULL"
  end

  def self.down
    remove_column :stories, :created_at
  end
end
