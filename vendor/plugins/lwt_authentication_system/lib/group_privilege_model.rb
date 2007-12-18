if( GroupPrivilege rescue true )
  class ::GroupPrivilege < ActiveRecord::Base
  end
end

GroupPrivilege.class_eval do
  set_table_name "groups_privileges"
  
  belongs_to :group
  belongs_to :privilege
end
