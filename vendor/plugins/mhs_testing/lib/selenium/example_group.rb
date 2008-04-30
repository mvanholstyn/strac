module Spec
  module Rails
    module Example
      class SeleniumExampleGroup < RailsExampleGroup
        Spec::Example::ExampleGroupFactory.register(:selenium, self)

        self.use_transactional_fixtures = false

        include ActionController::UrlWriter
        self.default_url_options = { :host => "#{Selenium.configuration.test_server_host}:#{Selenium.configuration.test_server_port}" }

        include Selenium::Helpers

        before(:all) do
          Selenium::Server.connect!
          @browser = Selenium.configuration.browsers.first
        end

        before(:each) do
          @browser.connect!
          # @browser.reconnect!
        end
        
        def reset!
          @browser.reconnect!
        end

        # %w{eval}.each { |m| undef_method m }
        %w{open type}.each { |method| undef_method(method) }
    
        def method_missing(*args)
          _execute_with_selenium(*args.map(&:to_s))
        end

        def _execute_with_selenium(command, *arguments)
          selenium_command = @browser.selenium_command(command)
      
          if command.starts_with?('assert_')
            assert_block("Selenium assertion failure - #{command}: #{arguments.join(', ')}\n  #{@browser.version}") do
              @browser.execute(selenium_command, *arguments)
            end
          else
            @browser.execute(selenium_command, *arguments)
          end
        end
      end
    end
  end
end
