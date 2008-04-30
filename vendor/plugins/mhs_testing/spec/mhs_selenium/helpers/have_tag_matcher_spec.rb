require File.expand_path(File.dirname(__FILE__)) + '/../../spec_helper'

describe RailsSeleniumStory do
  before(:all) do
    Selenium::Server.connect!
    @browser = Selenium.configuration.browsers.first
  end

  before(:each) do
    @browser.connect!
    # @browser.reconnect!
  end
  
  it "can find a single element given a basic CSS selector" do
    @browser.open "/"
    @browser.wait_for_page_to_load 10_000
    matcher = RailsSeleniumStory::Matchers::HaveTag.new "div#parent"
    matcher.matches?(@browser).should be_true
  end
end

