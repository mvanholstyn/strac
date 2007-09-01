class AddDefaultAuthenticationData < ActiveRecord::Migration
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
    acts_as_login_model
    has_one :group
    
    attr_accessor :salt
  end
  
  def self.up
    developer_privilege = Privilege.create! :name => 'developer'
    customer_privilege = Privilege.create! :name => 'customer'
    user_privilege = Privilege.create! :name => 'user'
    
    developer_group = Group.create! :name => 'Developer'
    developer_group.privileges << user_privilege << developer_privilege
    
    customer_group = Group.create! :name => 'Customer'
    customer_group.privileges << user_privilege << customer_privilege
    
    administrator = User.create! :username =>'admin', :email_address => "admin@example.com",
                                 :password => 'password', :password_confirmation => 'password', :group_id => developer_group.id
  end

  def self.down
    Privilege.delete_all
    Group.delete_all
    User.delete_all
  end
end
