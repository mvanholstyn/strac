require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/_people_sidebar.html.erb" do
  def render_it
    assigns[:project] = @project
    render :partial => "projects/people_sidebar", :locals => { :project => @project }
  end

  before do
    @users = [
      mock_model(User, :full_name => "Davey Jones"),
      mock_model(User, :full_name => "Captain Jack")
    ]
    @project = mock_model(Project, :users => @users)
  end
  
  it "displays the names of the users associated with the project" do
    render_it
    @users.each do |user|
      response.should have_text(user.full_name.to_regexp)
    end
  end
end