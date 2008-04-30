module LwtTesting
  module Sees
    def see_signup_or_login_page
      response.should have_tag("form#login_form")
    end

    def see_the_project_invitation_form
      response.should have_tag("form#new_invitation")
    end

    def see_empty_stories_list
      assert_select '.stories .story_card', false
    end

    def see_errors(error)
      response.should have_tag("#errorExplanation") do
        response.should have_text(error)
      end
    end
  
    def see_project_summary(&blk)
      assert_select '#project_summary', &blk
    end

    def see_stories_header(text)
      assert_select '#stories .header', text.to_regexp
    end

    def see_story_card_for(story_id)
      assert_select %|#story_#{story_id}.story_card|
    end
  
    def see_the_user_has_logged_in(email)
      assert_select ".logged_in", email.to_regexp, true
    end
    
    def see_story_in_stories_list_for_phase(story)
      response.should have_tag('.phase .stories #story_' + story.id.to_s)
    end
  
    def see_empty_project_phases_list
      response.should have_tag("table tr.phase", 0)
    end
  
    def see_new_project_phase_form
      response.should have_tag('form#new_phase')
    end
  
    def see_create_project_phase_errors
      response.should have_tag('#errorExplanation')
    end
  
    def see_empty_project_phase_stories_list
      response.should have_tag('.phase .stories:empty')
    end
  
    def see_newly_created_project_phase
      see_project_phase_name "FooBaz"
      see_project_phase_description "Descriptisio"
    end
  
    def see_project_phase_name(name=nil)
      name ||= @project.name
      response.should have_text(name.to_regexp)
    end
  
    def see_project_phase_description(description=nil)
      description ||= @project.description
      response.should have_text(description.to_regexp)
    end
    
  end
end

module Spec::Story::World
  include LwtTesting::Sees
end