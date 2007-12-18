if( Group rescue true )
  class ::Group < ActiveRecord::Base
  end
end

Group.class_eval do
  has_many :users unless Group.reflect_on_association :users
  has_many :privileges, :through => :group_privileges unless Group.reflect_on_association :privileges
  has_many :group_privileges, :dependent => :destroy unless Group.reflect_on_association :group_privileges

  validates_presence_of :name
end
