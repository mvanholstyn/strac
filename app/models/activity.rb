class Activity < ActiveRecord::Base
  belongs_to :actor, :class_name => 'User', :foreign_key => 'actor_id'
  belongs_to :affected, :polymorphic => true
end