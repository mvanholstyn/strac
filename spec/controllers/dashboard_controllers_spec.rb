require File.dirname(__FILE__) + '/../spec_helper'

describe DashboardController, "user without 'user' privileges viewing the project page" do
  fixtures :users, :groups_privileges, :privileges, :groups

  before do
    @user = login_as :user_without_privileges
    @user.has_privilege?(:user).should_not be_true
  
    get :index
  end
  
  # TODO - shouldn't this redirect to the login path?
  it "redirects to the dashboard path" do
    response.should redirect_to(dashboard_path)
  end
  
end

describe DashboardController, "user with 'user' privileges viewing the project page" do
  fixtures :users, :groups_privileges, :privileges, :groups

  before do
    @user = login_as :joe
    @user.has_privilege?(:user).should be_true
    @user.projects.destroy_all
    @project = Project.create! :name => "Test Project"
    @user.projects << @project
  
    get :index
  end
  
  it "assigns projects to the logged in users projects" do
    assigns[:projects].should == @user.projects
  end
  
  it "assigns the activities_date to yesterday" do
    assigns[:activities_date].should == Date.today - 1
  end

end






