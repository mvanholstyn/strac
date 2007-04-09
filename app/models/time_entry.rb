# == Schema Information
# Schema version: 27
#
# Table name: time_entries
#
#  id            :integer(11)   not null, primary key
#  hours         :decimal(10, 2 
#  comment       :string(255)   
#  date          :date          
#  project_id    :integer(11)   
#  timeable_id   :integer(11)   
#  timeable_type :string(255)   
#

class TimeEntry < ActiveRecord::Base
  belongs_to :project
  belongs_to :timeable, :polymorphic => true
  
  validates_presence_of :hours, :date
end
