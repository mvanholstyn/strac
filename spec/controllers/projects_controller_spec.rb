require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectsController, "#index" do
  before do
    @user = Generate.user("user@example.com")
    
    login_as @user
    
    get :index
  end

  it "renders index template" do
    response.should be_success
    response.should render_template('index')
  end

  it "assigns a list of projects for the current project that the user has permissions on" do
    assigns[:projects].size.should == @user.projects.size
  end
end

describe ProjectsController, "#new" do
  before do
    @user = Generate.user("user@example.com")

    login_as @user
    
    get :new
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

describe ProjectsController, "#show - user with proper privileges can view a project" do
  before do
    @user = Generate.user("user@example.com")
    @project = Generate.project("Some Project")
    @project.users << @user

    login_as @user
    
    get :show, :id => @project.id 
  end

  it "renders show template" do
    response.should be_success
    response.should render_template('show')
  end

  it "assigns the requested project" do
    assigns[:project].should == @project
  end
end

describe ProjectsController, "#create" do
  before do
    @user = Generate.user("user@example.com")
    
    login_as @user
    
    post( :create, :project => { :name => "Project Foo" } )
  end

  it "redirects to the created project's page" do
    @project = Project.find_by_name("Project Foo")
    response.should be_redirect
    path = project_path(:id=>@project.id)
    response.should redirect_to(path)
  end
end

describe ProjectsController, "#update - user with proper privileges to update a project" do
  before do
    @user = Generate.user("user@example.com")
    @project = Generate.project("Some Project")
    @project.users << @user
    
    login_as @user
    
    put(:update, :id => @project.id, :project => { :name => "Project HRM" })
  end

  it "redirects to the updated project's path" do
    response.should be_redirect
    path = project_path(:id=>@project.id)
    response.should redirect_to(path)
  end
end

describe ProjectsController, "#update - user without the proper privileges to update a project" do
  before do
    @user = Generate.user("user@example.com")
    @project = Generate.project("Some Project")

    login_as @user
    
    put( :update, :id => @project.id, :project => { :name=>"" })
  end
    
  it "render the edit template" do
    response.should redirect_to(dashboard_path)
  end
end

describe ProjectsController, "#edit - user with proper privileges to edit a project" do
  before do
    @user = Generate.user("user@example.com")
    @project = Generate.project("Some Project")
    @project.users << @user
    
    login_as @user
    
    get :edit, :id => @project.id 
  end

  it "renders edit template" do
    response.should be_success
    response.should render_template('edit')
  end

  it "assigns the requested iteration" do
    assigns[:project].should == @project
  end
end

describe ProjectsController, "#destroy - user with proper privileges to destroy the project" do
  before do
    @user = Generate.user("user@example.com")
    @project = Generate.project("Some Project")
    @project.users << @user
    
    login_as @user
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
