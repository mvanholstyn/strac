ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails/story_adapter'
require File.expand_path(File.dirname(__FILE__) + "/../spec/spec_helpers/model_generation")
require File.expand_path(File.dirname(__FILE__) + "/../spec/spec_helpers/string_extensions")

def click_link(path)
  select_link(path).follow
end

def click_project_link_for(project)
  click_link project_path(project)
end


def login_as(email, password)
  submit_form 'login_form' do |form|
    form.user.email_address = email
    form.user.password = password
  end
end

def go_to_the_dashboard
  get dashboard_path
end