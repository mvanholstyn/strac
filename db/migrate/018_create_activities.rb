class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.column :actor_id, :integer
      t.column :action, :string
      t.column :affected_id, :integer
      t.column :affected_type, :string
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :activities
  end
end
