class AddStatusAttributeToStories < ActiveRecord::Migration
  class Status < ActiveRecord::Base; end

  def self.up
    create_table :statuses do |t|
      t.column :name, :string
    end
    
    Status.create! :name => 'defined'
    Status.create! :name => 'in progress'
    complete_status = Status.create! :name => 'complete'
    Status.create! :name => 'rejected'
    Status.create! :name => 'blocked'
    
    add_column :stories, :status_id, :integer
    
    Story.find_all_by_complete( true ).each do |story|
      story.status_id = complete_status.id
      story.save!
    end
    
    remove_column :stories, :complete
  end

  def self.down
    add_column :stories, :complete, :boolean
        
    Story.find_all_by_status_id( Status.find_by_name( "complete" ).id ).each do |story|
      story.complete = true
      story.save!
    end
    
    drop_table :statuses
    remove_column :stories, :status_id
  end
end
