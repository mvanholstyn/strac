class AddComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :content, :text
      t.column :created_at, :datetime
      t.column :user_id, :integer
      t.column :commenter_id, :integer
      t.column :commenter_type, :string
    end
  end

  def self.down
    drop_table :comments
  end
end
