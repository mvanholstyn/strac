class User < ActiveRecord::Base
  acts_as_login_model
  
  belongs_to :company
  has_many :stories, :as => :responsible_party
  has_many :projects, :through => :project_permissions
  has_many :project_permissions, :foreign_key => "accessor_id", :as => :accessor
  
  
  def full_name
    "#{first_name} #{last_name}"
  end
  alias :name :full_name
end
