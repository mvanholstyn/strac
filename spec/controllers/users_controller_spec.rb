require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController, "user without 'crud_users' privileges" do
#   fixtures :users, :groups_privileges, :privileges, :groups, :projects, :project_permissions
# 
#   before do
#     @user = login_as :user_without_privileges
#     @user.has_privilege?(:crud_user).should_not be_true
#     @project = projects(:project1)
#   end
#   
#   # TODO - there is an issue with calling these w/o permissions. Perhaps in LWT auth?
#   it "redirects to the dashboard path on index" 
#   # do
#   #   get :index
#   #   response.should redirect_to(dashboard_path)
#   # end
# 
#   # TODO - there is an issue with calling these w/o permissions. Perhaps in LWT auth?
#   it "redirects to the dashboard path on new" 
#   # do
#   #   get :new
#   #   response.should redirect_to(dashboard_path)
#   # end
# 
#   it "redirects to the dashboard path on show" do
#     get :show, :id => @project.id
#     response.should redirect_to(dashboard_path)
#   end
#   
# end
# 
# 
# describe UsersController, "user with 'crud_users' privileges requesting index" do
#   fixtures :users, :groups_privileges, :privileges, :groups, :projects, :project_permissions
# 
#   before do
#     @user = login_as :crud_users
#     @user.has_privilege?(:crud_users).should be_true
#     @project = projects(:project1)
#   
#     get :index
#   end
#   
#   it "renders index template" do
#     response.should be_success
#     response.should render_template 'index'
#   end
# 
#   it "assigns a list of projects for the current project that the user has permissions on" do
#     assigns[:projects].size.should == 1
#     assigns[:projects].should include(@project)
#   end
# end
# 
# describe UsersController, "user with 'crud_users' privileges requesting new" do
#   fixtures :users, :groups_privileges, :privileges, :groups, :projects, :project_permissions
# 
#   before do
#     @user = login_as :crud_users
#     @user.has_privilege?(:crud_users).should be_true
#     @project = projects(:project1)
#   
#     get :new, :id => @project.id
#   end
#   
#   it "renders new template" do
#     response.should be_success
#     response.should render_template 'new'
#   end
# 
#   it "assigns an blank project" do
#     assigns[:project].should_not be_nil
#     assigns[:project].should be_new_record
#   end
# end
# 
# describe UsersController, "user with 'crud_users' privileges requesting show" do
#   fixtures :users, :groups_privileges, :privileges, :groups, :projects, :project_permissions
# 
#   before do
#     @user = login_as :crud_users
#     @user.has_privilege?(:crud_users).should be_true
#     @project = projects(:project1)
#   
#     get :show, :id => @project.id 
#   end
#   
#   it "renders show template" do
#     response.should be_success
#     response.should render_template 'show'
#   end
# 
#   it "assigns the requested project" do
#     assigns[:project].should == @project
#   end
# end
# 
# describe UsersController, "user with 'users' privileges requesting show" do
#   fixtures :users, :groups_privileges, :privileges, :groups, :projects, :project_permissions
# 
#   before do
#     @user = login_as :joe
#     @user.has_privilege?(:user).should be_true
#     @project = projects(:project1)
#   
#     get :show, :id => @project.id 
#   end
#   
#   it "renders show template" do
#     response.should be_success
#     response.should render_template 'show'
#   end
# 
#   it "assigns the requested project" do
#     assigns[:project].should == @project
#   end
# end
# 
# describe UsersController, "user with 'crud_users' privileges requesting create successfully" do
#   fixtures :users, :groups_privileges, :privileges, :groups, :projects, :project_permissions
# 
#   before do
#     @user = login_as :crud_users
#     @user.has_privilege?(:crud_users).should be_true
#   
#     Project.find_by_name.should be_nil
#     post( :create, :project => { :name => "Project Foo" } )
#     @project = Project.find_by_name("Project Foo")
#   end
#   
#   it "redirects to the created project's page" do
#     response.should be_redirect
#     path = project_path(:id=>@project.id)
#     response.should redirect_to(path)
#   end
# 
#   it "assigns the passed in name to the new project" do
#     @project.name.should == "Project Foo"
#   end
# end
# 
# describe UsersController, "user with 'crud_users' privileges requesting create unsuccessfully" do
#   fixtures :users, :groups_privileges, :privileges, :groups, :projects, :project_permissions
# 
#   before do
#     @user = login_as :crud_users
#     @user.has_privilege?(:user).should be_true
#     Project.destroy_all
# 
#     @old_count = Project.count
#     post( :create, :project => { :name => '' } )
#   end
#   
#   it "render the new template" do
#     response.should render_template("new")
#   end
#   
#   it "should not add an iteration for the project" do
#     @old_count.should == Project.count
#   end
# end
# 
# describe UsersController, "user with 'crud_users' privileges requesting update successfully" do
#   fixtures :users, :groups_privileges, :privileges, :groups, :projects, :project_permissions
# 
#   before do
#     @user = login_as :crud_users
#     @user.has_privilege?(:crud_users).should be_true
#     @project = projects(:project1)
# 
#     put(:update, :id => @project.id, :project => { :name => "Project HRM" })
#   end
#   
#   it "redirects to the created iteration's index page" do
#     response.should be_redirect
#     path = project_path(:id=>@project.id)
#     response.should redirect_to(path)
#   end
# end
# 
# describe UsersController, "user with 'crud_users' privileges requesting update unsuccessfully" do
#   fixtures :users, :groups_privileges, :privileges, :groups, :projects, :project_permissions
# 
#   before do
#     @user = login_as :crud_users
#     @user.has_privilege?(:crud_users).should be_true
#     @project = projects(:project1)
# 
#     put( :update, :id => @project.id, :project => { :name=>"" })
#   end
#   
#   it "render the edit template" do
#     response.should render_template("edit")
#   end
#   
#   it "should not update the iteration for the project" do
#     @project.reload
#     @project.name.should_not == ''
#   end
# end
# 
# 
# describe UsersController, "user with 'crud_users' privileges requesting edit" do
#   fixtures :users, :groups_privileges, :privileges, :groups, :projects, :project_permissions
# 
#   before do
#     @user = login_as :crud_users
#     @user.has_privilege?(:user).should be_true
#     @project = projects(:project1)
#   
#     get :edit, :id => @project.id 
#   end
#   
#   it "renders edit template" do
#     response.should be_success
#     response.should render_template 'edit'
#   end
# 
#   it "assigns the requested iteration" do
#     assigns[:project].should == @project
#   end
# end

# describe UsersController, "user with 'crud_users' privileges requesting destroy" do
#   fixtures :users, :groups_privileges, :privileges, :groups, :projects, :project_permissions
#   
#   before do
#     @user = login_as :crud_users
#     @user.has_privilege?(:user).should be_true
#     @project = projects(:project1)
#   end
# 
#   it "destroys an existing user" do
#     @old_count = Project.count
#     delete :destroy, :id=>@project.id 
#     Project.count.should be(@old_count-1)
#   end
# 
#   it "redirects the user to the iterations index page" do
#     delete :destroy, :id=>@project.id 
#     assert_redirected_to projects_path    
#   end
  
end


