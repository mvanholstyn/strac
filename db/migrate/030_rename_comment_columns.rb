class RenameCommentColumns < ActiveRecord::Migration
  def self.up
    rename_column :comments, :commenter_id, :commentable_id
    rename_column :comments, :commenter_type, :commentable_type
    rename_column :comments, :user_id, :commenter_id
  end

  def self.down
    rename_column :comments, :commenter_id, :user_id
    rename_column :comments, :commentable_id, :commenter_id
    rename_column :comments, :commentable_type, :commenter_type
  end
end