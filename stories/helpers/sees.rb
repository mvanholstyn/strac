class ActionController::IntegrationTest
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
end