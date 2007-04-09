# == Schema Information
# Schema version: 27
#
# Table name: activities
#
#  id         :integer(11)   not null, primary key
#  actor_id   :integer(11)   
#  action     :string(255)   
#  created_at :datetime      
#  project_id :integer(11)   
#

class Activity < ActiveRecord::Base
  belongs_to :project
  belongs_to :actor, :class_name => 'User', :foreign_key => 'actor_id'
    
  validates_presence_of :actor_id, :action
end
