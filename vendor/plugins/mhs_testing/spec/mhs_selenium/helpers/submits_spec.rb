require File.expand_path(File.dirname(__FILE__)) + '/../../spec_helper'

class ExampleForm < RailsSeleniumStory::Helpers::SeleniumForm
end

describe RailsSeleniumStory::Helpers::SeleniumForm do
  before do
    @browser = mock("Browser")
  end
  
  it "builds a selenium command for setting the value on a field using method-style access" do
    form = ExampleForm.new(@browser, 'myform')
    @browser.should_receive(:get_eval).with( "selenium.browserbot.getCurrentWindow().eval(\"var ochg=$$(\\\"form#myform *[name='expense[date]']\\\").first().setValue(\\\"2007-01-01\\\").onchange;if(ochg){ ochg(); };\"); ")
    form.expense.date = '2007-01-01'

    @browser.should_receive(:get_eval).with("selenium.browserbot.getCurrentWindow().eval(\"var ochg=$$(\\\"form#myform *[name='expense[description]']\\\").first().setValue(\\\"foobar\\\").onchange;if(ochg){ ochg(); };\"); ")
    form.expense.description = 'foobar'
  end
  
  it "builds a selenium command for setting the value on a field using hash-key style access" do
    form = ExampleForm.new(@browser, 'myform')
    @browser.should_receive(:get_eval).with("selenium.browserbot.getCurrentWindow().eval(\"var ochg=$$(\\\"form#myform *[name='expense[date]']\\\").first().setValue(\\\"2007-01-01\\\").onchange;if(ochg){ ochg(); };\"); ")
    form['expense'].date = '2007-01-01'

    @browser.should_receive(:get_eval).with("selenium.browserbot.getCurrentWindow().eval(\"var ochg=$$(\\\"form#myform *[name='expense[description]']\\\").first().setValue(\\\"foobar\\\").onchange;if(ochg){ ochg(); };\"); ")
    form['expense']['description'] = 'foobar'
  end
  
  it "builds a selenium command for setting the value on a field within a form using a block" do
    @browser.should_receive(:get_eval).with("selenium.browserbot.getCurrentWindow().eval(\"var ochg=$$(\\\"form#myform *[name='expense[date]']\\\").first().setValue(\\\"2007-01-01\\\").onchange;if(ochg){ ochg(); };\"); ")
    @browser.should_receive(:get_eval).with("selenium.browserbot.getCurrentWindow().eval(\"var ochg=$$(\\\"form#myform *[name='expense[description]']\\\").first().setValue(\\\"foobar\\\").onchange;if(ochg){ ochg(); };\"); ")
    ExampleForm.new(@browser, 'myform') do |form|
      form.expense.date = '2007-01-01'
      form.expense.description = 'foobar'
    end
  end

  it "builds a selenium command to click a submit button" do
    @browser.should_receive(:get_eval).with("selenium.browserbot.getCurrentWindow().eval(\"$$('form#myform').first().onsubmit();\")")
    ExampleForm.new(@browser, 'myform').submit    
  end
end
