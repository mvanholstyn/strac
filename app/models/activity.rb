class Activity < ActiveRecord::Base
  belongs_to :project
  belongs_to :actor, :class_name => 'User', :foreign_key => 'actor_id'
  belongs_to :direct_object, :polymorphic => true
  belongs_to :indirect_object, :polymorphic => true
  
  validates_presence_of :actor_id, :direct_object_id, :direct_object_type
end