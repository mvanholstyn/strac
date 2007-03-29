class Project < ActiveRecord::Base
  has_many :time_entries
  has_many :stories
  has_many :iterations
end
