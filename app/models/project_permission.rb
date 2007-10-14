# == Schema Information
# Schema version: 32
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
  
  # Class Methods
  class << self
    def find_all_projects_for_user user
      conditions = build_conditions_for_user user
      find(:all, :conditions => conditions).map{ |project_permission| project_permission.project }
    end
  
    def find_project_for_user project_id, user
      conditions = build_conditions_for_user user
      conditions.first << " AND project_id = ?"
      conditions << project_id
      project_permission = find(:first, :conditions => conditions)
      project_permission ? project_permission.project : nil
    end
  
    private

    def build_conditions_for_user user
      ["(accessor_id = ? AND accessor_type = ?)", user.id, user.class.name]
    end
  end
  
end
