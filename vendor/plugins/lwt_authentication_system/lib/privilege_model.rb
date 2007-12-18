if( Privilege rescue true )
  class ::Privilege < ActiveRecord::Base
  end
end

Privilege.class_eval do
  has_many :groups, :through => :group_privileges unless Privilege.reflect_on_association :groups
  has_many :group_privileges, :dependent => :destroy unless Privilege.reflect_on_association :group_privileges
  
  validates_presence_of :name
end
