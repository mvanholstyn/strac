Selenium::configure do |config|
  config.browser 'firefox'
  # config.browser 'safari'
  # config.browser 'iexplore'

  # config.close_browser_at_exit = true
  config.stop_selenium_server = false
  config.stop_test_server = false
end
