class AddPositionToPriority < ActiveRecord::Migration
  def self.up
    add_column :priorities, :position, :integer
    
    Priority.delete_all

    Priority.create! :name => 'High', :color => "red"
    Priority.create! :name => 'Medium', :color => "yellow"
    Priority.create! :name => 'Low', :color => "green"
  end

  def self.down
    remove_column :priorities, :position
  end
end
