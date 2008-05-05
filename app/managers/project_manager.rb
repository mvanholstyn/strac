class ProjectManager
  class << self
    def get_project_for_user(project_id, user)
      if project=ProjectPermission.find_project_for_user(project_id, user)
        project
      else
        raise AccessDenied
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
  
  def initialize(project_id, user)
    @project = self.class.get_project_for_user(project_id, user)
  end
  
  def update_story_points(story_id, points)
    if story=@project.stories.find(story_id)
      if story.update_attribute :points, points
        yield Multiblock[:success, story] if block_given?
      else
        yield Multiblock[:failure, story] if block_given?
      end
    else
      raise ResourceNotFoundError
    end
  end
end
