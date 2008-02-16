class Spec::Rails::Example::ControllerExampleGroup
  include ActionController::UrlWriter

  def self.controller_class
    self.described_type
  end
  
  def controller_class
    self.class.controller_class
  end
  
  def stub_login_for(controller_klass)
    @user = mock_model(User)
    @project ||= mock_model(Project, :id => 91)

    controller.stub!(:current_user).and_return(@user)
    controller_klass.login_model.stub!(:find).and_return(@user)
    @user.stub!(:has_privilege?).and_return(true)
  end
  
  def login_as(user)
    stub_login_for controller_class
  end 

  def old_login_as(user)
    if user.is_a?(String) || user.is_a?(Symbol)
      user = users(user)
    end
    @request.session[:current_user_id] = user.id
    User.current_user = user
  end

  def set_cookie(name)
    value = "#{name}_cookie_value"
    request.cookies[name] = CGI::Cookie.new('name' => name, 'value' => value)
    value
  end
  
  def stub_filters_of_type(type, options)
    controller.class.send!("#{type}_filters").each do |filter_name|
      next if options[:except].respond_to?(:include?) && options[:except].include?(filter_name)
      next if options[:except] == filter_name
      controller.stub!(filter_name).and_return(true)
    end    
  end
  
  def stub_before_filters!(options = {})
    stub_filters_of_type(:before, options)
  end

  def stub_after_filters!(options = {})
    stub_filters_of_type(:before, options)
  end
end
