# == Schema Information
# Schema version: 41
#
# Table name: users
#
#  id                           :integer(11)   not null, primary key
#  password_hash                :string(255)   
#  first_name                   :string(255)   
#  last_name                    :string(255)   
#  email_address                :string(255)   
#  group_id                     :integer(11)   
#  company_id                   :integer(11)   
#  created_at                   :datetime      
#  updated_at                   :datetime      
#  active                       :boolean(1)    
#  salt                         :string(255)   
#  remember_me_token            :string(255)   
#  remember_me_token_expires_at :datetime      
#

class User < ActiveRecord::Base
  acts_as_login_model

  has_many :stories, :as => :responsible_party
  has_many :projects, :through => :project_permissions
  has_many :project_permissions, :foreign_key => "accessor_id", :as => :accessor
    
  def full_name
    "#{first_name} #{last_name}"
  end
  alias :name :full_name
end
