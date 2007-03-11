class AddDefaultAuthenticationData < ActiveRecord::Migration
  def self.up
    developer_privilege = Privilege.create! :name => 'developer'
    customer_privilege = Privilege.create! :name => 'customer'
    user_privilege = Privilege.create! :name => 'user'
    
    developer_group = Group.create! :name => 'Developer'
    developer_group.privileges << user_privilege << developer_privilege
    
    customer_group = Group.create! :name => 'Customer'
    customer_group.privileges << user_privilege << customer_privilege
    
    administrator = User.create! :username =>'admin', :password => 'password', :password_confirmation => 'password', :group => developer_group
  end

  def self.down
    Privilege.delete_all
    Group.delete_all
    User.delete_all
  end
end
