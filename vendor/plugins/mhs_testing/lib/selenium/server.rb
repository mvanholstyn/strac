module Selenium
  class Server
    class << self
      def test_server
        @test_server ||= SubProcess.find(test_server_command)
      end
      
      def selenium_server
        @selenium_server ||= SubProcess.find(selenium_server_command)
      end
      
      def test_server_command
        "mongrel_rails start -c #{RAILS_ROOT} -e test -p #{configuration.test_server_port}"
      end
      
      def selenium_server_command
        server_path = File.expand_path(File.join(File.dirname(__FILE__), "selenium-server.jar"))
        "java -jar #{server_path} -port #{configuration.selenium_server_port}"
      end
      
      def configuration
        Selenium.configuration
      end
      
      def connect!(options = {})
        unless test_server
          @test_server = SubProcess.start(test_server_command)
        end
              
        unless selenium_server
          @selenium_server = SubProcess.start(selenium_server_command)
        end
      end
    
      def disconnect!
        if configuration.stop_test_server? && test_server
          @test_server.stop
          @test_server = nil
        end
      
        if configuration.stop_selenium_server? && selenium_server
          @selenium_server.stop
          @selenium_server = nil
        end
      end
    end
  end
end