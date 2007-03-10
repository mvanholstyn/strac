class Company < ActiveRecord::Base
  has_many :users
  has_many :stories, :as => :responsible_party
end
