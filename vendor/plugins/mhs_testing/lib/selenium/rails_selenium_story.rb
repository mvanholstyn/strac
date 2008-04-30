class RailsSeleniumStory < RailsStory  
  self.use_transactional_fixtures = false
  
  include ActionController::UrlWriter
  Dir[File.expand_path(File.dirname(__FILE__)) + '/helpers/*.rb'].each { |f| require f }
  include Helpers
  include Matchers
    
  def self.initialize_selenium
#    Selenium::Server.connect!
    @@browser = Selenium.configuration.browsers.first    
  end
  
  def self.connect_browser
    @@browser.connect!
  end
    
  %w{open type}.each { |method| undef_method(method) }

  def self.browser
    @@browser
  end
  
  def browser
    self.class.browser
  end
  
  def response
    browser
  end

  def method_missing(*args)
    _execute_with_selenium(*args.map(&:to_s))
  end

  def _execute_with_selenium(command, *arguments)
    selenium_command = browser.selenium_command(command)

    if command.starts_with?('assert_')
      assert_block("Selenium assertion failure - #{command}: #{arguments.join(', ')}\n  #{browser.version}") do
        browser.execute(selenium_command, *arguments)
      end
    else
      browser.execute(selenium_command, *arguments)
    end
  end
end


class RailsSeleniumStoryListener 
  # STORY LISTENERS
  def run_started(scenario_count)
    RailsSeleniumStory.initialize_selenium
  end
  
  def story_started(title, narrative)
    RailsSeleniumStory.connect_browser
  end
  
  def story_ended(title, narrative)
  end
  
  def run_ended
  end
  
  def collected_steps(steps)
  end
  
  # SCENARIO LISTENERS
  def scenario_started(story_title, scenario_name)
  end
  
  def scenario_succeeded(story_title, scenario_name)
  end
  
  def scenario_pending(story_title, scenario_name, reason)
  end
  
  def scenario_failed(story_title, scenario_name, err)
  end
  
  # STEP LISTENERS
  def found_scenario(type, name)
  end
  
  def step_upcoming(type, step_name, *args)
  end
  
  def step_succeeded(type, step_name, *args)
  end
  
  def step_pending(type, step_name, *args)
  end
  
  def step_failed(type, step_name, *args)
    # str =<<-EOT
    #   tell application "Firefox"
    #     activate
    #   end tell
    # EOT
    # `osascript -e '#{str}'`
    # capture_screenshot "/tmp/#{step_name}.png"
  end
end
