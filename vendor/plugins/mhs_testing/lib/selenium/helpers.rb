module Selenium
  module Helpers
   def get_style(locator, attribute) 
     get_eval("window.$$('#{locator}').first().getStyle('#{attribute}')")
    end
  end
end