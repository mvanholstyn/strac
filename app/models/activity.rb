# == Schema Information
# Schema version: 26
#
# Table name: activities
#
#  id                   :integer(11)   not null, primary key
#  actor_id             :integer(11)   
#  action               :string(255)   
#  direct_object_id     :integer(11)   
#  direct_object_type   :string(255)   
#  created_at           :datetime      
#  indirect_object_id   :integer(11)   
#  indirect_object_type :string(255)   
#  project_id           :integer(11)   
#

class Activity < ActiveRecord::Base
  belongs_to :project
  belongs_to :actor, :class_name => 'User', :foreign_key => 'actor_id'
  belongs_to :direct_object, :polymorphic => true
  belongs_to :indirect_object, :polymorphic => true
  
  validates_presence_of :actor_id, :direct_object_id, :direct_object_type
end
