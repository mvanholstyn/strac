# == Schema Information
# Schema version: 27
#
# Table name: project_permissions
#
#  id            :integer(11)   not null, primary key
#  project_id    :integer(11)   
#  accessor_id   :integer(11)   
#  accessor_type :string(255)   
#

class ProjectPermission < ActiveRecord::Base
  belongs_to :accessor, :polymorphic => true
  belongs_to :project
end
