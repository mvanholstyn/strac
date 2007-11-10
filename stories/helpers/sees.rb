def see_errors(error)
  response.should have_tag("#errorExplanation") do
    response.should have_text(error)
  end
end