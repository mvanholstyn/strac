module Spec::Example::ExampleGroupMethods
  def it_delegates(*args)
    options = args.extract_options!
    methods = args
    src = options[:on]
    to = options[:to]
    raise "Missing an object to call the method on, pass in :on" unless src
    raise "Missing an object to ensure the method delegated to, pass in :to" unless to

    method_options = options.reject{|k,v| [:on, :to].include?(k)}
    methods.each {|m| method_options[m] = m}
    method_options.each do |source_method, to_method|
      it "delegates ##{source_method} to @#{to}.#{to_method}" do
        obj = instance_variable_get "@#{to}"
        _src = instance_variable_get "@#{src}"
        return_val = stub("return val")
        obj.should_receive(to_method).and_return(return_val)
        _src.send!(source_method).should == return_val
      end
    end
  end
  
  def it_provides_liquid_methods(*methods)
    it "defines ##{self.described_type}::LiquidDrop (declare liquid_methods to do this automatically)" do
      self.class.described_type.const_defined?(:LiquidDrop).should be_true
    end
    
    if self.described_type.const_defined?(:LiquidDrop)
      klass = self.described_type::LiquidDrop
      describe klass do
        before do
          @presenter = stub("presenter")
          @drop = klass.new(@presenter)
        end
        methods.each do |method|
          it "provides ##{method} to liquid" do
            return_value = stub("return value")
            @presenter.should_receive(method).and_return(return_value)
            @drop.send(method).should == return_value
          end
        end
      end
    end
  end

  def it_has_accessors(attribute, options)
    on_variable_name = options[:on]
    raise "Missing an object to call the method on, pass in :on" unless on_variable_name

    it "has accessors for ##{attribute}" do
      on = instance_variable_get "@#{on_variable_name}"
      on.send("#{attribute}=", :the_value)
      on.send(attribute).should == :the_value
    end
    
    if options.keys.include?(:default)
      it "defaults ##{attribute} to #{options[:default].inspect}" do
        on = instance_variable_get "@#{on_variable_name}"
        on.send(attribute).should == options[:default]
      end
    end
  end
  alias_method :it_has_accessor, :it_has_accessors
  
end

class Spec::Rails::Example::ViewExampleGroup
  def self.it_renders_a_link_to_unless_current(named_route)
    describe "when #{named_route} is the current page" do
      it "does not render a link to the #{named_route} page" do
        render_it
        response.should have_tag("a[href=?]", send(named_route))
      end
    end
    
    describe "when #{named_route} is not the current page" do
      it "renders a link to the #{named_route}" do
        template.stub!(:current_page?).and_return(true)
        render_it
        response.should_not have_tag("a[href=?]", send(named_route))
      end
    end
  end


  def self.it_renders_javascript_tags_for(*jsfiles)
    if jsfiles.include?(:defaults)
      jsfiles.delete(:defaults)
      jsfiles += [:prototype, :effects, :dragdrop, :controls]
    end
    jsfiles.each do |jsfile|
      it "renders a javascript tag for #{jsfile}.js" do
        render_it
        response.should have_tag('script[src*=?][type=text/javascript]', "#{jsfile}.js")
      end
    end
  end
  
  def self.it_renders_stylesheet_link_tags_for(*cssfiles)
    options = cssfiles.extract_options!
    media = options[:media] || "screen"
    cssfiles.each do |cssfile|
      it "renders a link tag for #{cssfile}.css" do
        render_it
        response.should have_tag('link[href*=?][media=?][rel=stylesheet][type=text/css]', "#{cssfile}.css", media)
      end
    end
  end
  
  def self.it_does_not_render_stylesheet_link_tags_for(*cssfiles)
    cssfiles.each do |cssfile|
      it "does not render a link tag for #{cssfile}.css" do
        render_it
        response.should_not have_tag('link[href*=?][rel=stylesheet][type=text/css]', "#{cssfile}.css")
      end
    end
  end
  
  def self.it_renders_error_messages_for(*models)
    models.each do |model|
      it "renders error messages for #{model}" do
        instance = instance_variable_get "@#{model}"
        errors = stub("Errors", :count => 1, :full_messages => ["attribute1 error1"])
        instance.stub!(:errors).and_return(errors)
        render_it
        response.should have_tag("#errorExplanation", "attribute1 error1".to_regexp)
      end
    end
  end
end

module Spec::Example::ExampleGroupMethods
  def model_class
    self.described_type
  end

  def it_requires attribute
    it "requires #{attribute}" do
       model = self.class.model_class.new
       assert_validates_presence_of model, attribute
    end
  end

  def it_protects attribute
    it "protects #{attribute} from mass assignment" do
      default_value = self.class.model_class.new[attribute]
      model = self.class.model_class.new(attribute => !default_value)
      model[attribute].should == default_value
    end
  end

  def it_validates_uniqueness_of attribute, options
    it "validates the uniqueness of #{attribute}" do
      model = self.class.model_class.new
      if options[:values]
        options[:values].each_pair do |attribute, value|
          model[attribute] = value
        end
      else
        model[attribute] = options[:value]
      end
      assert_attribute_invalid model, attribute
    end

    if options[:allow_nil]
      it "doesn't enforce uniqueness on #{attribute} when it is nil" do
        assert self.class.model_class.count(:conditions => {attribute => nil}) > 0, "must have a record where #{attribute} is nil to check this validation"
        model = self.class.model_class.new
        model[attribute] = nil
        assert_attribute_valid model, attribute
      end
    else
      it "enforces uniqueness on #{attribute} when it is nil" do
        model = self.class.model_class.new
        model[attribute] = nil
        assert_attribute_invalid model, attribute
      end
    end
  end

  def it_validates_inclusion_of attribute, options
    options[:exclusions].each do |exclusion|
      it "does not allow #{attribute} to have a value of #{exclusion.inspect}" do
        model = self.class.model_class.new
        model[attribute] = exclusion
        assert_attribute_invalid(model, attribute)
      end
    end
    options[:inclusions].each do |inclusion|
      it "allows #{attribute} to have a value of #{inclusion.inspect}" do
        model = self.class.model_class.new
        model[attribute] = inclusion
        assert_attribute_valid(model, attribute)
      end
    end
  end

  def it_has_one association, options={}
    it "has one #{association}" do
      self.class.model_class.should have_association(:has_one, association.to_sym, options)
    end
  end


  def it_has_many association, options={}
    it "has many #{association}" do
      self.class.model_class.should have_association(:has_many, association.to_sym, options)
    end
  end

  def it_belongs_to association, options={}
    a_or_an = association.to_s =~ /^[aeiou]/i ? "an" : "a"
    it "belongs to #{a_or_an} #{association}" do
      self.class.model_class.should have_association(:belongs_to, association.to_sym, options)
    end
  end

end

class Spec::Rails::Example::ControllerExampleGroup  
  def self.controller_class
    self.described_type
  end
  
  class << self
    def it_hides_the_actions(*actions)
      actions.each do |action|
        it "hides the action ##{action}" do
          controller.class.hidden_actions.should include(action.to_s)
        end
      end
    end
    alias_method :it_hides_the_action, :it_hides_the_actions
  end
  
  def self.it_does_not_require_login(method, action)
    it_skips_before_filter(:login_required, action)
  end
  
  def self.it_skips_before_filter(filter, action)
    describe controller_class, "##{action}" do
      it "skips the '#{filter}' before filter" do
        filter_not_present_or_exluded(filter, action).should be_true
      end
          
      def filter_not_present_or_exluded(filter, action)
        filter = controller.class.find_filter(filter)
        if filter
          controller.class.filter_excluded_from_action?(filter, action.to_s)
        else
          true
        end
      end
    end
  end
  
  def self.it_renders_the_default_template(*args) #method, action, *options)
    if args.size == 3
      method, action, params = args
    elsif args.size ==4
      method = args[0..1]
      action, params = args[2..-1]
    else
      raise ArgumentError, "takes parameters: [method, action, params] or [xhr, method, action, params]"
    end

    it "renders the #{action} template" do
      send *args
      response.should render_template(action)
    end
  
    it "is successful" do
      send *args
      response.should be_success
    end
  end
  
  def self.it_requires_login(method, action, params={})
    describe controller_class, "#{method} ##{action} requires login" do
      before do
        stub_before_filters! :except => :login_required
      end
      
      describe controller_class, "when not logged in" do
        it "redirects to signup" do
          send method, action, params
          response.should redirect_to(login_path)
        end
    
        it "does not call the action" do
          controller.should_not_receive(action)
          send method, action, params
        end
      end
  
      describe controller_class, "when logged in" do
        before do
          stub_login_for controller_class
        end
        
        it "calls the action" do
          controller.should_receive(action)
          send method, action, params
        end
      end
    end
  end
  
  def self.it_requires_a_superuser(method, action, params={})
    describe controller_class, "#{method} ##{action} requires a superuser to be logged in" do
      before do
        stub_before_filters! :except => :superuser_required
      end
      
      describe controller_class, "when a user is not logged in" do
        it "redirects the user to the signup page" do
          send method, action, params
          response.should redirect_to(signup_path)
        end
    
        it "sets an error message telling them that they need to log in or sign up" do
          send method, action, params
          flash[:error].should == "You need to sign up or log in before you can do that."
        end
      end 

      describe controller_class, "when a user is logged in but is not a superuser" do
        before do
          login_with_user
        end
    
        it "sets an error message telling the user they don't have access" do
          send method, action, params
          flash[:error].should =~ /You don't have access to/i
        end
    
        describe controller_class, "when a user came from a referring page" do
          before do
            @referer = "http://www.google.com"
            request.headers["HTTP_REFERER"] = @referer
          end
      
          it "redirects the user :back to the referring page" do
            send method, action, params
            response.should redirect_to(@referer)
          end
        end
    
        describe controller_class, "when a user did not come from a referring page" do
          before do
            request.headers["HTTP_REFERER"] = nil
          end

          it "redirects the user to their home page" do
            send method, action, params
            response.should redirect_to(home_path)
          end
        end
      end
      
      describe controller_class, "when a superuser is logged in" do
        before do
          user = login_with_user
          user.stub!(:superuser?).and_return(true)
        end
        
        it "calls the action" do
          controller.should_receive(action)
          send method, action, params
        end
      end
      
    end
  end
end
