class AddProjectPermissions < ActiveRecord::Migration
  def self.up
    create_table :project_permissions do |t|
      t.column :project_id, :integer
      t.column :accessor_id, :integer
      t.column :accessor_type, :string
    end
  end

  def self.down
    drop_table :project_permissions
  end
end
