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
  
  def self.find_all_projects_for_user user
    find( :all, :conditions => [ "(accessor_id = ? AND accessor_type = ?) OR (accessor_id = ? AND accessor_type = ?)", 
                                 user.id, user.class.name, user.company.id, user.company.class.name ] ).map{ |pp| pp.project }
  end
  
  def self.find_project_for_user project_id, user
    find( :first, :conditions => [ "project_id = ? AND ( (accessor_id = ? AND accessor_type = ?) OR (accessor_id = ? AND accessor_type = ?) )", 
                                   project_id, user.id, user.class.name, user.company.id, user.company.class.name ] ).project
  end
  
end
