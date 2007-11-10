def click_link(path)
  select_link(path).follow
end

def click_project_link_for(project)
  click_link project_path(project)
end
