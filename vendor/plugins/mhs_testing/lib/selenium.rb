module Selenium
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end

require File.join(File.dirname(__FILE__), "selenium", "browser")
require File.join(File.dirname(__FILE__), "selenium", "configuration")
require File.join(File.dirname(__FILE__), "selenium", "driver")
require File.join(File.dirname(__FILE__), "selenium", "exceptions")
require File.join(File.dirname(__FILE__), "selenium", "helpers")
require File.join(File.dirname(__FILE__), "selenium", "server")
require File.join(File.dirname(__FILE__), "selenium", "sub_process")
