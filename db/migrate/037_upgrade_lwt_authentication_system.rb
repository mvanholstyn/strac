class UpgradeLwtAuthenticationSystem < ActiveRecord::Migration
  def self.up
    create_table :user_reminders do |t|
      t.column :user_id, :integer
      t.column :token, :string
      t.column :expires_at, :datetime
    end
  end

  def self.down
    drop_table :user_reminders
  end
end
