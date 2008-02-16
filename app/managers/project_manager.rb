module Strac
  class ProjectManager
    class << self
      def all_projects_for_user(user)
        ProjectPermission.find_all_projects_for_user(user)
      end
      
      def get_project_for_user(project_id, user)
        if project=ProjectPermission.find_project_for_user(project_id, user)
          project
        else
          raise Strac::AccessDenied
        end
      end
      
      def update_project_for_user(project_id, user, project_attrs, user_ids)
        project = get_project_for_user(project_id, user)
        if project.update_attributes(project_attrs)
          project.update_members user_ids
          yield Multiblock[:success, project] if block_given?
        else
          yield Multiblock[:failure, project] if block_given?
        end
      end
    end
  end
end