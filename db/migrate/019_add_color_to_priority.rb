class AddColorToPriority < ActiveRecord::Migration
  class Priority < ActiveRecord::Base; end
  
  def self.up
    add_column :priorities, :color, :string
  
    Priority.delete_all

    Priority.create! :name => 'Low', :color => "green"
    Priority.create! :name => 'Medium', :color => "yellow"
    Priority.create! :name => 'High', :color => "red"
  end

  def self.down
    remove_column :priorities, :color
  end
end
