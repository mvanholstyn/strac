class Priority < ActiveRecord::Base
  has_many :stories
  
  acts_as_list
end
