module RailsSeleniumStory::Helpers

  def get_via_redirect(path)
    open path
  end

  # This method is overridden because selenium tests can't be reset
  # like sessions like Rails integration tests, but we want to be
  # able to re-use integration helpers.
  def reset!
  end

end
