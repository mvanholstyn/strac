class AddMessageToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :message, :string
  end

  def self.down
    remove_column :invitations, :message
  end
end
