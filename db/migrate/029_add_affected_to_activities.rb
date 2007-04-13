class AddAffectedToActivities < ActiveRecord::Migration
  def self.up
    Activity.delete_all
    add_column :activities, :affected_id, :integer
    add_column :activities, :affected_type, :string
  end

  def self.down
    remove_column :activities, :affected_id
    remove_column :activities, :affected_type
  end
end
