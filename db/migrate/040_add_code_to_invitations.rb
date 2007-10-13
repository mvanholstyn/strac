class AddCodeToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :code, :string  
  end

  def self.down
    remove_column :invitations, :code  
  end
end
