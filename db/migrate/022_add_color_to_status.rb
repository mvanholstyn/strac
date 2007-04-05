class AddColorToStatus < ActiveRecord::Migration
  def self.up
    add_column :statuses, :color, :string
    
    Status.find_by_name( 'defined' ).update_attributes! :color => "blue"
    Status.find_by_name( 'in progress' ).update_attributes! :color => "yellow"
    Status.find_by_name( 'complete' ).update_attributes! :color => "green"
    Status.find_by_name( 'rejected' ).update_attributes! :color => "black"
    Status.find_by_name( 'blocked' ).update_attributes! :color => "red"
  end

  def self.down
    remove_column :statuses, :color
  end
end
