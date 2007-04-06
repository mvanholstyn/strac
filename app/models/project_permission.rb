class ProjectPermission < ActiveRecord::Base
  belongs_to :accessor, :polymorphic => true
  belongs_to :project
end
