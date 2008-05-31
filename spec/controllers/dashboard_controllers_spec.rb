require File.dirname(__FILE__) + '/../spec_helper'

describe DashboardController, "user without 'user' privileges viewing the project page" do
  before do
    @user = stub_login_for DashboardController
    @user.stub!(:has_privilege?).with(:user).and_return(false)  
  end
  
  it "redirects to the dashboard path" do
    get :index
    response.should redirect_to(dashboard_path)
  end
end

describe DashboardController, "user with 'user' privileges viewing the project page" do

  before do
    @user = stub_login_for DashboardController
    @user.stub!(:has_privilege?).with(:user).and_return(true)
    @user.stub!(:projects).and_return([])
    @project = mock_model(Project)
    ProjectPermission.stub!(:find_all_projects_for_user).and_return(@project)
  end
  
  it "assigns projects to the logged in users projects" do
    ProjectPermission.should_receive(:find_all_projects_for_user).and_return(@project)
    get :index
    assigns[:projects].should == @project
  end
end
