module Selenium
  class Browser
    attr_reader :name, :command
    
    def initialize(name, options = {})
      options = options.reverse_merge(:command => "*#{name}")
      @name, @command = name, options[:command]
    end
    
    def connect!
      unless @selenium
        configuration = Selenium.configuration
        @selenium = SeleniumDriver.new(configuration.selenium_server_host, configuration.selenium_server_port,
          command, "http://#{configuration.test_server_host}:#{configuration.test_server_port}/")
        @selenium.start
      end
    end
    
    def disconnect!
      configuration = Selenium.configuration
      if configuration.close_browser_at_exit? && @selenium
        @selenium.stop
        @selenium = nil
      end
    end
    
    def reconnect!
      disconnect!
      connect!
    end
    
    class << self
      def disconnect!
        Selenium.configuration.browsers.each do |browser|
          browser.disconnect!
        end
      end
    end
    
    # %w{select eval}.each { |m| undef_method m }
    %w{open type}.each { |method| undef_method(method) }

    def method_missing(method_id, *arguments)
      command = selenium_command(method_id)
      execute(command, *arguments)
    end
    
    def execute(*args)
      @selenium.send(*args)
    end
    
    def selenium_command(method)
      method = method.to_s
      methods = SeleniumDriver.instance_methods
      
      if methods.include?(method)
        method
        
      # assert_ methods return the corresponding is_ method
      elsif md = /^assert_/.match(method) and methods.include?("is_#{md.post_match}")
        "is_#{md.post_match}"
        
      # ? methods return the result of the corresponding is_ method
      elsif md = /\?$/.match(method) and methods.include?("is_#{md.pre_match}")
        "is_#{md.pre_match}"
      
      # get_ selenium methods can be used without the get_ prefix
      elsif methods.include?("get_#{method}")
        "get_#{method}"
        
      else
        raise InvalidCommand, method
      end
    end
  end
end
