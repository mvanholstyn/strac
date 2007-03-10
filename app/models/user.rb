class User < ActiveRecord::Base
  acts_as_login_model
  
  belongs_to :company
end
