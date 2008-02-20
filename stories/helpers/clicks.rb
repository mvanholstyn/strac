# def click_link(path)
#   select_link(path).follow
# end

def click_link(text, select = '')
  select = "a" + select
  if %w{# .}.include? text.first
    link = assert_select("#{select}#{text}", 1).first
  else
    link = assert_select("#{select}[href=?]", text).first     
  end
  assert_not_nil link, "link not found to click with contents: #{text}"
  path = link['href']
  assert_not_nil path, "Could not find URL for link with contents: #{text}"
  # Handling for DELETE and PUT links
  if link['onclick'] =~ /.*method = '(\w+)'.*m.setAttribute\('name', '_method'\).*m.setAttribute\('value', '(\w+)'\)/
    form_method = $1
    http_method = $2
    send form_method.downcase, link['href'], {'_method' => http_method}, { 'HTTP_REFERER' => request.request_uri } 
    follow_all_redirects
    return
  elsif link['onclick'] =~ /Ajax\.Request\('(.*?)',/
    path = $1
  elsif link['onclick'] =~ /Ajax\.Updater\('[^']*', '(.*?)',/
    path = $1
  end

  get path, {}, { 'HTTP_REFERER' => request.request_uri }
  follow_all_redirects
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

def click_tags_view_link
  click_link ".tags_view"
end

def click_logout_link
  click_link logout_path
end