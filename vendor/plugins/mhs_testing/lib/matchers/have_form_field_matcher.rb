module Spec::Matchers 
  class HaveFormField
    def initialize(options={})
      options.each_pair do |key,val|
        instance_variable_set "@#{key}", val
      end
    end
    
    def assert_select(*args)
      begin
        @scope.send(:assert_select, *args)
      rescue ::Test::Unit::AssertionFailedError => @error
      end
    end
  
    def matches?(target)
      args = []
      selector = ""
      selector += "#{@inside} " if @inside
      selector += @tag.to_s
      (selector += "[id=?]" ; args << @id) if @id
      (selector += "[type=?]" ; args << @type) if @type
      (selector += "[name=?]" ; args << @name) if @name
      selector += "[checked=checked]" if @checked == true

      if @value
        selector += "[value=?]"
        args << @value
      end
      args << @contents if @contents
      assert_select(selector, *args)
      if @checked == false
        selector += "[checked]"
        args.push(false)
        assert_select(selector, *args)
      end
      @error.nil?
    end
  
    def failure_message
      @error.message
    end
    alias_method :negative_failure_message, :failure_message
  end  
  
  # Actual matcher that is exposed.  
  def have_check_box(options)
    have_form_field(options.merge(:tag => :input, :type => :checkbox))
  end
  
  # Example: response.should have_radio_button(:id => 'trip[transportation_expense]_state_car_true')
  def have_radio_button(options)
    have_form_field(options.merge(:tag => :input, :type => :radio))
  end
  
  def have_form_field(options)
    HaveFormField.new(options.merge(:scope => self))
  end
  
  def have_text_field(options)
    have_form_field(options.merge(:tag => :input, :type => :text))
  end  
  
  def have_password_field(options)
    have_form_field(options.merge(:tag => :input, :type => :password))
  end  
  
  def have_text_area(options)
    options[:contents] = options.delete(:value) if options[:value]
    have_form_field(options.merge(:tag => :textarea))
  end
  
  def have_hidden_field(options)
    have_form_field(options.merge(:tag => :input, :type => :hidden))
  end
  
  def have_calendar_date_select(options)
    options[:value] = options[:value].strftime(CalendarDateSelect.date_format_string(false)) if options[:value]
    have_text_field(options)
  end
  
  def have_submit_button(options={})
    have_form_field(options.merge(:tag => :input, :type => :submit))
  end
end  