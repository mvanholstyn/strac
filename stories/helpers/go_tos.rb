def go_to_the_dashboard
  get dashboard_path
  follow_redirect! if response.redirect?
end

def go_to_story(project, story)
  get story_path(project, story)
  follow_redirect! while response.redirect?
end

def go_to_edit_story(project, story)
  get edit_story_path(project, story)
  follow_redirect! while response.redirect?
end

def go_to_project_phases(project)
  get project_phases_path(project)
  follow_redirect! while response.redirect?  
end