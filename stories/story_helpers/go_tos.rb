module LwtTesting
  module GoTos
    def follow_all_redirects
      if response.content_type == "text/html"
        follow_redirect! while response.redirect?
      elsif response.content_type == "text/javascript"
        if md=response.body.match(/window.location.href = "([^"]+)"/)
          get md.captures.first
        end
      end
      true
    end
    
    def go_to_the_dashboard
      get dashboard_path
      follow_all_redirects
    end

    def go_to_story(project, story)
      get story_path(project, story)
      follow_all_redirects
    end

    def go_to_edit_story(project, story)
      get edit_story_path(project, story)
      follow_all_redirects
    end

    def go_to_project_phases(project)
      get project_phases_path(project)
      follow_all_redirects  
    end
  end
end

module Spec::Story::World
  include LwtTesting::GoTos
end