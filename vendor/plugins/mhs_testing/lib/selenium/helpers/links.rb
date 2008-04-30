module RailsSeleniumStory::Helpers
  def link_containing_text text
    "//a[contains(text(),'#{text}')]"
  end
end