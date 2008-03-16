module LwtTesting
  module Misc
    def follow_all_redirects
      follow_redirect! while response.redirect?
      true
    end

    def grab_project_summary(selector)
      assert_select(".project_summary #{selector}").first.children.to_s
    end
  
    def move_story_to_phase(story, phase)
      go_to_edit_story(story.project, story)
      submit_edit_phase_form do |form|
        form.story.bucket_id = phase.id.to_s
      end
    end
  end
end

module Spec::Story::World
  include LwtTesting::Misc
end