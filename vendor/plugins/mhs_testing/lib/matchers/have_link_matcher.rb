module Spec::Matchers 
  # Notes:
  #  - using onclick adds a [onclick*=?] rather than a [onclick=?]
  class HaveLink  
    def initialize(options={})
      options.each_pair do |key,val|
        instance_variable_set "@#{key}", val
      end
      @href ||= '#'
      @href = @href.gsub('&', '&amp;')
    end

    def matches?(target)
      assert_select(build_onclick_expression)
      @error.nil?
    end
    
    def build_onclick_expression
      @onclick
    end
    
    def assert_select(onclick_expression)
      begin
        if onclick_expression
          @scope.send(:assert_select,"a#{@selector}[href=?][onclick*=?]", @href, onclick_expression)
        else
          @scope.send(:assert_select,"a#{@selector}[href=?]", @href)
        end
      rescue ::Test::Unit::AssertionFailedError => @error
      end
    end
  
    def failure_message
      @error.message
    end
    alias_method :negative_failure_message, :failure_message
  end  
  
  # Actual matcher that is exposed.  
  def have_link(options)
    HaveLink.new(options.merge(:scope => self))
  end
  
  def have_remote_link(options)
    HaveLink.new(options.merge(:scope => self, :remote => true))
  end  
end  