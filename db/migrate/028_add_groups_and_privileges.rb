class AddGroupsAndPrivileges < ActiveRecord::Migration
  class Privilege < ActiveRecord::Base ; end

  class GroupPrivilege < ActiveRecord::Base
    set_table_name "groups_privileges"
    belongs_to :group
    belongs_to :privilege
  end
  
  class Group < ActiveRecord::Base 
    has_many :users
    has_many :privileges, :through => :group_privileges
    has_many :group_privileges, :dependent => :destroy  
  end
  
  class User < ActiveRecord::Base
    has_one :group
  end
    
  def self.up
    Privilege.destroy_all
    
    crud_companies_privilege = Privilege.create! :name => 'crud_companies'
    crud_projects_privilege = Privilege.create! :name => 'crud_projects'
    crud_users_privilege = Privilege.create! :name => 'crud_users'
    crud_companies_users_privilege = Privilege.create! :name => 'crud_companies_users'
    user_privilege = Privilege.create! :name => 'user'
    
    developer_group = Group.find_by_name 'Developer'
    developer_group.privileges.clear
    developer_group.privileges << user_privilege
    
    customer_group = Group.find_by_name 'Customer'
    customer_group.privileges.clear
    customer_group.privileges << user_privilege
    
    customer_admin_group = Group.create! :name => 'Customer Admin'
    customer_admin_group.privileges.clear
    customer_admin_group.privileges << user_privilege << crud_companies_users_privilege
    
    admin_group = Group.create! :name => 'Admin'
    admin_group.privileges << user_privilege << crud_companies_privilege << crud_projects_privilege << crud_users_privilege
    
    User.update_all [ "group_id = ?", admin_group ]
    
    [ 'mvanholstyn', 'zdennis' ].each do |username|
      user = User.find_by_username username
      next unless user
      user.group = admin_group
      user.save!
    end
  end

  def self.down
  end
end
