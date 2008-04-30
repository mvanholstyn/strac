module Spec::Matchers 
  class ExistFor
    include Test::Unit::Assertions
    include ActionController::Assertions::SelectorAssertions
    
    attr_reader :attribute, :message, :html
    
    def initialize(attribute, message = nil)
      @attribute = attribute
      @message = message
    end
  
    def matches?(html)
      @html = html
      begin
        assert_select @html, "li", /^#{create_pattern}/i
      rescue ::Test::Unit::AssertionFailedError => ex
        return false
      end
      true
    end

    def failure_message
      chunks = []
      chunks << "expected an error on the '#{attribute}' attribute"
      chunks << "with a message of '#{message}'" unless message.nil?
      chunks << "in #{html}"
      chunks.join(' ')
    end
    
    def negative_failure_message
      chunks = []
      chunks << "expected to not see an error on the '#{attribute}' attribute"
      chunks << "in #{html}"
      chunks << "but did"
      chunks.join(' ')    
    end
    
    private
    
    def create_pattern
      pattern = attribute
      pattern = pattern + " #{message}" unless message.nil?
      pattern
    end
  end
  
  def exist_for(attribute, message = nil)
    ExistFor.new(attribute, message)
  end
end
