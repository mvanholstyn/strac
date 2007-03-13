class TimeEntry < ActiveRecord::Base
  belongs_to :project
  belongs_to :timeable, :polymorphic => true
  
  validates_presence_of :hours, :date
end
