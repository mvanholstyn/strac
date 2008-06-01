module RailsSeleniumStory::Matchers
  class HaveTag
    include RailsSeleniumStory::Helpers::EscapeString
    extend RailsSeleniumStory::Helpers::EscapeString
    
    attr_reader :content, :tag
  
    def initialize(tag, content=nil, &block)
      @@scopes ||= []
      @tag = escape_string(tag, 2)
      @content = content
      @block = block
      @@scopes << self
    end
  
    def matches?(browser, &block)
      @block.call if @block
      block.call if block
      if @@scopes.size == 1
        if @content
          @js = "$$('#{@tag}').#{self.class.build_selector_call(self)}.any();"
        else
          @js = "$$('#{@tag}').any()"
        end
      else
        @js = []
        while scope=@@scopes.shift
          if @js.empty?
            @js << "$$('#{scope.tag}').#{self.class.build_selector_call(scope)}"
          else
            @js << ".select(function(el){ return el.down('#{scope.tag}')}).#{self.class.build_selector_call(scope)}"
          end
        end
        @js << ".length > 0;"
        @js = @js.join("")
      end
      @@scopes.clear
      browser.wait_for_condition(
        %|selenium.browserbot.getCurrentWindow().eval("#{@js}");|,
        10_000
      )
    end
    
    def failure_message
      "Couldn't match content with javascript:\n#{@js}"
    end
    
    def self.build_selector_call(scope)
      "select(function(el){ return (/#{create_content_regex(scope.content)}/i).test(el.innerHTML); })"
    end
    
    def self.create_content_regex(content)
      escape_regex(content)
    end
  end
  
  def have_tag(tag, content=nil, &blk)
    HaveTag.new(tag, content, &blk)
  end
  
  def with_tag(tag, content)
    have_tag(tag, content)
  end
end


