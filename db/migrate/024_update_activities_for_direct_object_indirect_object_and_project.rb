class UpdateActivitiesForDirectObjectIndirectObjectAndProject < ActiveRecord::Migration
  def self.up
    rename_column :activities, :affected_id, :direct_object_id
    rename_column :activities, :affected_type, :direct_object_type
    
    add_column :activities, :indirect_object_id, :integer
    add_column :activities, :indirect_object_type, :string
    add_column :activities, :project_id, :integer
  end

  def self.down
    rename_column :activities, :direct_object_id, :affected_id
    rename_column :activities, :direct_object_type, :affected_type
    remove_column :activities, :indirect_object_id
    remove_column :activities, :indirect_object_type
    remove_column :activities, :project_id
  end
end
