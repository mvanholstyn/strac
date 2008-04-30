module Spec
  module Matchers
    class BeVisible # :nodoc:
      include RailsSeleniumStory::Helpers::EscapeString
      extend RailsSeleniumStory::Helpers::EscapeString

      def initialize(browser)
        @browser = browser
      end
      
      def matches?(selector_string)
        @selector_string = selector_string
        selector_string = "css=#{@selector_string}"
        selector_string = "css=##{@selector_string}" unless @browser.is_element_present(selector_string)
        @browser.is_visible selector_string
      end
      
      def failure_message
        @failure_message || "expected <#{@selector_string.inspect}> to be visible, but it wasn't"
      end

      def negative_failure_message
        @negative_failure_message || "expected <#{@selector_string.inspect}> to NOT be visible, but it was"
      end

    end
    
    def be_visible
      BeVisible.new RailsSeleniumStory.browser
    end
  end
end