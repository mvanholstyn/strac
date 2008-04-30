module RailsSeleniumStory::Helpers
  def see_an_error_explanation(locator='css=#errorExplanation', &blk)
    wait_until do
      is_element_present(locator)
    end
    yield browser if block_given?
  end
  
  def see_message(message)
    wait_for_content_to_match message, :element => "//*[@id='notice']"
  end
  
  def see_link_with_href path_or_options, msg="Missing link"
    path_or_options = { :href => path_or_options } if path_or_options.is_a?(String)
    assert(
      is_element_present(descendant('a', path_or_options)),
      msg
    )    
  end
  
  def see_link_containing_text text, msg="Missing link"
    assert(
      is_element_present(link_containing_text(text)),
      msg
    )    
  end
  
  def see_link path_or_options, msg="Missing link"
    see_link_with_href path_or_options, msg
  end
end
