class UpdatePermissionsAndPrivileges < ActiveRecord::Migration
  def self.up
    # customer_admin = Group.find_by_name "Customer Admin"
    # customer = Group.find_by_name "Customer"
    # User.update_all "group_id=#{customer.id}", :group_id=>customer_admin.id
    # 
    # admin = Group.find_by_name "Admin"
    # developer = Group.find_by_name "Developer"
    # User.update_all "group_id=#{developer.id}", :group_id=>admin.id
    #     
  end

  def self.down
    # raise ActiveRecord::IrreversibleMigration
  end
end
