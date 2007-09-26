require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectsController, "user without 'crud_projects' privileges" do

  before do
    # @user = generate_user_without_any_privileges
    # login_as @user
    # @user.has_privilege?(:user).should_not be_true
    # @project = projects(:project1)
  end
  
  # TODO - there is an issue with calling these w/o permissions. Perhaps in LWT auth?
  it "redirects to the dashboard path on index" 
  # do
  #   get :index
  #   response.should redirect_to(dashboard_path)
  # end

  # TODO - there is an issue with calling these w/o permissions. Perhaps in LWT auth?
  it "redirects to the dashboard path on new" 
  # do
  #   get :new
  #   response.should redirect_to(dashboard_path)
  # end

  it "redirects to the dashboard path on show" 
  # do
  #   get :show, :id => @project.id
  #   response.should redirect_to(dashboard_path)
  # end
  
end


describe ProjectsController, "#index" do
  describe ProjectsController, "user with 'crud_projects' privileges requesting index" do
    before do
      @user = generate_user_with_proper_privileges_to_crud_a_project
      login_as @user
      get :index
    end

    it "has a user with the 'crud_projects' privilege" do
      @user.group.privileges.should include(@crud_projects_privilege)
    end
  
    it "renders index template" do
      response.should be_success
      response.should render_template('index')
    end

    it "assigns a list of projects for the current project that the user has permissions on" do
      assigns[:projects].size.should == @user.projects.size
      assigns[:projects].should include(@project)
    end
  end
end

describe ProjectsController, "#new" do
  describe ProjectsController, "user with 'crud_projects' privileges requesting new" do
    before do
      @user = generate_user_with_proper_privileges_to_crud_a_project
      login_as @user
      get :new, :id => @project.id
    end
  
    it "has a user with the 'crud_projects' privilege" do
      @user.group.privileges.should include(@crud_projects_privilege)
    end

    it "renders new template" do
      response.should be_success
      response.should render_template('new')
    end

    it "assigns an blank project" do
      assigns[:project].should_not be_nil
      assigns[:project].should be_new_record
    end
  end
end

describe ProjectsController, "#show" do
  describe ProjectsController, "user with 'crud_projects' privileges can view a project" do
    before do
      @user = generate_user_with_proper_privileges_to_crud_a_project
      login_as @user
      get :show, :id => @project.id 
    end
  
    it "has a user with the 'crud_projects' privilege" do
      @user.group.privileges.should include(@crud_projects_privilege)
    end

    it "renders show template" do
      response.should be_success
      response.should render_template('show')
    end

    it "assigns the requested project" do
      assigns[:project].should == @project
    end
  end

  describe ProjectsController, "user with 'user' privileges can view a project" do
    before do
      @user = generate_user_with_proper_privileges_to_view_a_project
      login_as @user
      get :show, :id => @project.id 
    end

    it "has a user with the 'user' privilege" do
      @user.group.privileges.should include(@user_privilege)
    end
  
    it "renders show template" do
      response.should be_success
      response.should render_template('show')
    end

    it "assigns the requested project" do
      assigns[:project].should == @project
    end
  end
end

describe ProjectsController, "#create" do
  describe ProjectsController, "user with proper privileges to create a project" do
    before do
      @user = generate_user_with_proper_privileges_to_crud_a_project
      login_as @user
      post( :create, :project => { :name => "Project Foo" } )
    end

    it "has a user with the 'crud_projects' privilege" do
      @user.group.privileges.should include(@crud_projects_privilege)
    end
  
    it "redirects to the created project's page" do
      @project = Project.find_by_name("Project Foo")
      response.should be_redirect
      path = project_path(:id=>@project.id)
      response.should redirect_to(path)
    end
  end

  describe ProjectsController, "user without the proper privileges to create a project" do
    before do
      @user = generate_user_without_the_proper_privileges_to_create_a_project
      login_as @user
      @old_count = Project.count
      post( :create, :project => { :name => '' } )
    end
  
    # TODO - i believe this to be a failure with LWT auth and how it handles redirects
    it "redirect to the dashboard_path" #do
#      response.should be_redirected_to(dashboard_path)
#    end
 
    # TODO - i believe this to be a failure with LWT auth and how it handles redirects
    it "should not add an iteration for the project" #do
#      @old_count.should == Project.count
#    end
  end
end

describe ProjectsController, "#update" do
  describe ProjectsController, "user with proper privileges to update a project" do
    before do
      @user = generate_user_with_proper_privileges_to_crud_a_project
      login_as @user
      put(:update, :id => @project.id, :project => { :name => "Project HRM" })
    end
  
    it "redirects to the updated project's path" do
      response.should be_redirect
      path = project_path(:id=>@project.id)
      response.should redirect_to(path)
    end
  end

  describe ProjectsController, "user without the proper privileges to update a project" do
    before do
      @user = generate_user_without_the_proper_privileges_to_edit_an_existing_a_project
      login_as @user
      put( :update, :id => @project.id, :project => { :name=>"" })
    end
    
    it "has a user who has the 'crud_projects' privilege" do
      @user.group.privileges.should include(@crud_projects_privilege)
    end
    
    it "has a user who doesn't have the 'user' privilege'" do
      @user.group.privileges.should_not include(@user_privilege)
    end
  
    it "render the edit template" do
      response.should redirect_to(dashboard_path)
    end
  end
end

 
describe ProjectsController, "#edit" do
  describe ProjectsController, "user with proper privileges to edit a project" do
    before do
      @user = generate_user_with_proper_privileges_to_crud_a_project
      login_as @user
      get :edit, :id => @project.id 
    end
  
    it "requires a user with the 'crud_projects' privilege" do
      @user.group.privileges.should include(@crud_projects_privilege)
    end

    it "has a group who has the privilege 'user'" do
      @group.privileges.should include(@user_privilege)
    end
  
    it "renders edit template" do
      response.should be_success
      response.should render_template('edit')
    end

    it "assigns the requested iteration" do
      assigns[:project].should == @project
    end
  end
end

describe ProjectsController, "#destroy" do
  describe ProjectsController, "user with proper privileges to destroy the project" do
    before do
      @user = generate_user_with_proper_privileges_to_crud_a_project
      login_as @user
    end
  
    it "has a user with the 'crud_projects' privilege" do
      @user.group.privileges.should include(@crud_projects_privilege)
    end
  
    it "has a user who has the privilege 'user'" do
      @user.group.privileges.should include(@user_privilege)
    end

    it "destroys an existing iteration" do
      @old_count = Project.count
      delete :destroy, :id=>@project.id 
      assert_equal @old_count-1, Project.count
    end

    it "redirects the user to the iterations index page" do
      delete :destroy, :id=>@project.id 
      assert_redirected_to projects_path    
    end
  end  
end


def generate_user_without_any_privileges
  @user = Generate.user("Some User without privileges")
end

def generate_user_with_proper_privileges_to_view_a_project(username="some user")
  @user_privilege = Generate.privilege("user")
  @group = Generate.group("Some Group")
  @group.privileges << @user_privilege
  @user = Generate.user(username, :group => @group)
  @project = Generate.project("Some Project")
  @project.users << @user
  @user
end
  
def generate_user_with_proper_privileges_to_crud_a_project(username="some user")
  @crud_projects_privilege = Generate.privilege("crud_projects")
  @user_privilege = Generate.privilege("user")
  @group = Generate.group("Some Group")
  @group.privileges << @crud_projects_privilege
  @group.privileges << @user_privilege
  @user = Generate.user(username, :group => @group)
  @project = Generate.project("Some Project")
  @project.users << @user
  @user
end

def generate_user_without_the_proper_privileges_to_create_a_project
  @group = Generate.group("Some Group")
  @user = Generate.user("user without privileges", :group => @group)
  @project = Generate.project("Some Project")
  @project.users << @user
  @user  
end

def generate_user_without_the_proper_privileges_to_edit_an_existing_a_project
  @crud_projects_privilege = Generate.privilege("crud_projects")
  @group = Generate.group("Some Group")
  @group.privileges << @crud_projects_privilege
  @user = Generate.user("user without privileges", :group => @group)
  @project = Generate.project("Some Project")
  @project.users << @user
  @user
end
