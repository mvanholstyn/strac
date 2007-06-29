class AddUpdatedAtToStoriesAndActivities < ActiveRecord::Migration
  def self.up
    add_column :stories, :updated_at, :datetime
    add_column :activities, :updated_at, :datetime
    add_column :comments, :updated_at, :datetime
    add_column :companies, :created_at, :datetime
    add_column :companies, :updated_at, :datetime
    add_column :groups, :created_at, :datetime
    add_column :groups, :updated_at, :datetime
    add_column :invitations, :created_at, :datetime
    add_column :invitations, :updated_at, :datetime
    add_column :iterations, :created_at, :datetime
    add_column :iterations, :updated_at, :datetime
    add_column :groups_privileges, :created_at, :datetime
    add_column :groups_privileges, :updated_at, :datetime
    add_column :priorities, :created_at, :datetime
    add_column :priorities, :updated_at, :datetime
    add_column :privileges, :created_at, :datetime
    add_column :privileges, :updated_at, :datetime
    add_column :projects, :created_at, :datetime
    add_column :projects, :updated_at, :datetime
    add_column :project_permissions, :created_at, :datetime
    add_column :project_permissions, :updated_at, :datetime
    add_column :statuses, :created_at, :datetime
    add_column :statuses, :updated_at, :datetime
    add_column :time_entries, :created_at, :datetime
    add_column :time_entries, :updated_at, :datetime
    add_column :users, :created_at, :datetime
    add_column :users, :updated_at, :datetime
  end
  

  def self.down
    remove_column :stories, :updated_at
    remove_column :activities, :updated_at
    remove_column :comments, :updated_at
    remove_column :companies, :created_at
    remove_column :companies, :updated_at
    remove_column :groups, :created_at
    remove_column :groups, :updated_at
    remove_column :invitations, :created_at
    remove_column :invitations, :updated_at
    remove_column :iterations, :created_at
    remove_column :iterations, :updated_at
    remove_column :groups_privileges, :created_at
    remove_column :groups_privileges, :updated_at
    remove_column :priorities, :created_at
    remove_column :priorities, :updated_at
    remove_column :privileges, :created_at
    remove_column :privileges, :updated_at
    remove_column :projects, :created_at
    remove_column :projects, :updated_at
    remove_column :project_permissions, :created_at
    remove_column :project_permissions, :updated_at
    remove_column :statuses, :created_at
    remove_column :statuses, :updated_at
    remove_column :time_entries, :created_at
    remove_column :time_entries, :updated_at
    remove_column :users, :created_at
    remove_column :users, :updated_at
  end
end
