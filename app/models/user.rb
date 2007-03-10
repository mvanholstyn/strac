class User < ActiveRecord::Base
  acts_as_login_model
  
  belongs_to :company
  has_many :stories, :as => :responsible_party
  
  def full_name
    "#{first_name} #{last_name}"
  end
  alias :name :full_name
end
