def see_errors(error)
  response.should have_tag("#errorExplanation") do
    response.should have_text(error)
  end
end
  
def see_the_user_has_logged_in(email)
  assert_select ".logged_in", email.to_regexp, true
end
