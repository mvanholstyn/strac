module Spec::Matchers 
  # This class essential does the following:
  #   have_tag('form[id=?][onsubmit*=?]', form_id, onsubmit_text)
  #
  # Possible options are :id and :onsubmit
  #
  # Notes:
  #  - onsubmit is a partial text matcher using assert_selects [onsubmit*=sometext] matching capabilities
  class HaveRemoteForm 
    def initialize(options={})
      options.each_pair do |key,val|
        instance_variable_set "@#{key}", val
      end
    end
  
    def matches?(target)
      matcher = Spec::Rails::Matchers::AssertSelect.new(:assert_select, @scope, *build_selector)
      matcher.matches?(target)
    end
    
    def build_selector
      selector = 'form'
      args = []

      if @id
        selector << '[id=?]'
        args << @id
      end
      if @onsubmit
        selector << '[onsubmit*=?]'
        args << @onsubmit
      end
      [selector, args].flatten
    end
    

    def failure_message
      "Failed to find remote form for #{build_selector.join(', ')}"
    end
    alias_method :negative_failure_message, :failure_message
  end  
  
  # Actual matcher that is exposed.  
  def have_remote_form(options)
    HaveRemoteForm.new(options.merge(:scope => self))
  end  
end  