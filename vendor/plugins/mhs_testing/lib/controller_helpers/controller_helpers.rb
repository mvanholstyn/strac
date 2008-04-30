class Spec::Rails::Example::ControllerExampleGroup  
  def set_cookie(name)
    value = "#{name}_cookie_value"
    request.cookies[name] = CGI::Cookie.new('name' => name, 'value' => value)
    value
  end
  
  def stub_filters_of_type(type, options)
    controller.class.send!("#{type}_filters").each do |filter_name|
      next if options[:except].respond_to?(:include?) && options[:except].include?(filter_name)
      next if options[:except] == filter_name
      next if filter_name.is_a?(Proc)
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
