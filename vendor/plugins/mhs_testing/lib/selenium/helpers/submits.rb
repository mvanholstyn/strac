module RailsSeleniumStory::Helpers
  class SeleniumForm
    class Field
      attr_reader :value
      
      def [](key)
        send key
      end

      def []=(key,val)
        send "#{key}=", val
      end
      
      def initialize(form_id, browser)
        @form_id = form_id
        @browser = browser
        @name_components = []
      end

      def method_missing(name, *args)
        name = name.to_s
        if name =~ /^(.*)=$/
          @name_components << $1
          @value = args.first
         js = %|selenium.browserbot.getCurrentWindow().eval("#{self.to_javascript}"); |       
         @browser.get_eval js
        else
          @name_components << name
        end
        self
      end
      
      def to_javascript
        selector = "form##{@form_id} #{to_selector}"
        js = %|var ochg=$$("#{selector}").first().setValue("#{value}").onchange;|
        js << %|if(ochg){ ochg(); };|
        stripped_js = js.gsub('"', '\\"')
        stripped_js
      end
      
      def to_selector
        str = "*[name='"
        @name_components.each_with_index do |name, i|
          if i == 0
            str << name
          else
            str << "[#{name}]"
          end
        end
        str << "']"
        str
      end
    end
    
    def initialize(browser, form_id, &blk)
      @browser = browser
      @form_id = form_id
      @fields = []
      yield self if block_given?
    end

    def method_missing(name, *args)
      @fields << Field.new(@form_id, @browser)
      @fields.last.send(name, *args)
      @fields.last
    end
        
    def submit
      # Firefox 2 wouldn't consistently click the submit buttons so we revert to directly submitting the form
      # @browser.get_eval %|selenium.browserbot.getCurrentWindow().eval("$$('form##{@form_id} input[type=submit]').first().click();")|
      @browser.get_eval %|selenium.browserbot.getCurrentWindow().eval("$$('form##{@form_id}').first().onsubmit();")|
    end
  end
  
  def select_form(form_id, *args, &blk)
    SeleniumForm.new browser, form_id, &blk
  end

  def submit_form(form_id, *args, &blk)
    select_form(form_id, &blk).submit
  end
  
end
