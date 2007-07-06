class UpdateActivitiesToBeLessRigid < ActiveRecord::Migration
  class Activity < ActiveRecord::Base ; end
  
  def self.up
    Activity.delete_all
    remove_column :activities, :direct_object_id
    remove_column :activities, :direct_object_type
    remove_column :activities, :indirect_object_id
    remove_column :activities, :indirect_object_type
  end

  def self.down
    add_column :activities, :direct_object_id, :integer
    add_column :activities, :direct_object_type, :string
    add_column :activities, :indirect_object_id, :integer
    add_column :activities, :indirect_object_type, :string
  end
end
