module RailsSeleniumStory::Matchers
  class SeleniumExistFor
    include RailsSeleniumStory::Helpers::EscapeString
    
    attr_reader :attribute, :message, :html
    
    def initialize(attribute, message = nil)
      @attribute = attribute
      @message = message
    end

    def matches?(browser)
      result = browser.get_eval "selenium.browserbot.getCurrentWindow().$$('li').map(function(el){ return (/#{create_pattern}/i).test(el.innerHTML); }).include(true)"
      result == "false" ? false : true
    end

    def failure_message
      chunks = []
      chunks << "expected an error on the '#{attribute}' attribute"
      chunks << "with a message of '#{message}'" unless message.nil?
      chunks.join(' ')
    end

    def negative_failure_message
      chunks = []
      chunks << "expected to NOT see an error on the '#{attribute}' attribute"
      chunks << "but did"
      chunks.join(' ')
    end
    
    private
    
    def create_pattern
      pattern = attribute
      pattern = pattern + " #{message}" unless message.nil?
      escape_string(pattern)
    end
  end
  
  def exist_for(attribute, message = nil)
    SeleniumExistFor.new(attribute, message)
  end
end
