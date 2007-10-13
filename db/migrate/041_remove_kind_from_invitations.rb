class RemoveKindFromInvitations < ActiveRecord::Migration
  def self.up
    remove_column :invitations, :kind
  end

  def self.down
    add_column :invitations, :kind, :string
  end
end
