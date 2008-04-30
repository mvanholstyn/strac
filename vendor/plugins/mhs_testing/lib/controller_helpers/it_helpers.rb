class Spec::Rails::Example::ControllerExampleGroup  
  def self.controller_class
    self.described_type
  end
  
  def controller_class
    self.class.controller_class
  end  

  def self.it_renders_the_default_template(*args)
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
  
  def self.it_requires_login(method, action, params={})
    describe controller_class, "#{method} ##{action} requires login" do
      before do
        stub_before_filters! :except => :login_required
      end
      
      describe controller_class, "when not logged in" do
        it "redirects to signup" do
          send method, action, params
          response.should redirect_to(signup_path)
        end
    
        it "does not call the action" do
          controller.should_not_receive(action)
          send method, action, params
        end
      end
  
      describe controller_class, "when logged in" do
        before do
          login_with_user
        end
        
        it "calls the action" do
          controller.should_receive(action)
          send method, action, params
        end
      end
    end
  end
  
end