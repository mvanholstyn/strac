def click_link(path)
  select_link(path).follow
end

def click_project_link_for(project)
  click_link project_path(project)
end

def click_project_phase_link_for(project, phase)
  click_link project_phase_path(project, phase)
end

def click_project_phases_link_for(project)
  click_link project_phases_path(project)
end

def click_story(story)
  click_link
end

def click_stories_link(project)
  click_link stories_path(project)
end
