# == Schema Information
# Schema version: 32
#
# Table name: activities
#
#  id            :integer(11)   not null, primary key
#  actor_id      :integer(11)   
#  action        :string(255)   
#  created_at    :datetime      
#  project_id    :integer(11)   
#  affected_id   :integer(11)   
#  affected_type :string(255)   
#

class Activity < ActiveRecord::Base
  belongs_to :project
  belongs_to :actor, :class_name => 'User', :foreign_key => 'actor_id'
  belongs_to :affected, :polymorphic => true 
    
  validates_presence_of :actor_id, :action, :affected_id, :affected_type
end
