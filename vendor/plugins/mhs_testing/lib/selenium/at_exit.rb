if RAILS_ENV == 'test'
  at_exit { 
    Selenium::Browser.disconnect!
    Selenium::Server.disconnect!
  }
end
