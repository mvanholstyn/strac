class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.column :inviter_id, :integer
      t.column :recipient, :string
      t.column :project_id, :integer
      t.column :kind, :string
    end
  end

  def self.down
    drop_table :invitations
  end
end
