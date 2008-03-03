require File.dirname(__FILE__) + '/../spec_helper'

describe IterationsController, "user without 'user' privileges" do
  fixtures :users, :groups_privileges, :privileges, :groups, :projects, :buckets

  before do
    @user = old_login_as :user_without_privileges
    @user.has_privilege?(:user).should_not be_true
    @project = projects(:project1)
    @project.iterations.should_not be_empty
    @iteration = @project.iterations.first
  end
  
  # TODO - shouldn't this redirect to the login path?
  it "redirects to the dashboard path on index" do
    get :index, :project_id => @project.id
    response.should redirect_to(dashboard_path)
  end

  it "redirects to the dashboard path on new" do
    get :new, :project_id => @project.id
    response.should redirect_to(dashboard_path)
  end

  it "redirects to the dashboard path on show" do
    get :show, :project_id => @project.id, :id => @iteration.id
    response.should redirect_to(dashboard_path)
  end
end


describe IterationsController, "user with 'user' privileges requesting index" do
  fixtures :users, :groups_privileges, :privileges, :groups, :projects, :buckets

  before do
    @user = old_login_as :joe
    @user.has_privilege?(:user).should be_true
    @project = projects(:project1)
    @project.iterations.should_not be_empty
  
    get :index, :project_id => @project.id
  end
  
  it "renders index template" do
    response.should be_success
    response.should render_template('index')
  end

  it "assigns a list of iterations for the current project" do
    assigns[:iterations].size.should == 2
    assigns[:iterations].should include(@project.iterations.first)
    assigns[:iterations].should include(@project.iterations.last)
  end
end

describe IterationsController, "user with 'user' privileges requesting new" do
  fixtures :users, :groups_privileges, :privileges, :groups, :projects, :buckets

  before do
    @user = old_login_as :joe
    @user.has_privilege?(:user).should be_true
    @project = projects(:project1)
    @project.iterations.should_not be_empty
  
    get :new, :project_id => @project.id
  end
  
  it "renders new template" do
    response.should be_success
    response.should render_template('new')
  end

  it "assigns an iteration for the current project" do
    assigns[:iteration].should_not be_nil
    assigns[:iteration].project.should == @project
  end
end

describe IterationsController, "user with 'user' privileges requesting show" do
  fixtures :users, :groups_privileges, :privileges, :groups, :projects, :buckets

  before do
    @user = old_login_as :joe
    @user.has_privilege?(:user).should be_true
    @project = projects(:project1)
    @project.iterations.should_not be_empty
    @iteration = @project.iterations.first
  
    get :show, :project_id => @project.id, :id => @iteration.id
  end
  
  it "renders show template" do
    response.should be_success
    response.should render_template('show')
  end

  it "assigns the requested iteration" do
    assigns[:iteration].should == @iteration
  end
end

describe IterationsController, "user with 'user' privileges requesting create successfully" do
  fixtures :users, :groups_privileges, :privileges, :groups, :projects, :buckets

  before do
    @user = old_login_as :joe
    @user.has_privilege?(:user).should be_true
    @project = projects(:project1)
    @project.iterations.destroy_all
    @project.iterations.should be_empty
  
    @today, @tomorrow = Date.today, Date.today + 1
    post( :create, 
          :project_id => @project.id,
          :iteration => { 
            :start_date => @today, 
            :end_date => @tomorrow,
            :name => "Iteration Foo" } )
    @project.iterations(true)
  end
  
  it "redirects to the created iteration's index page" do
    response.should be_redirect
    path = iteration_path(:project_id=>@project.id, :id=>@project.iterations.first.id)
    response.should redirect_to(path)
  end

  it "creates a new iteration for the project" do
    @project.iterations.size.should == 1    
  end
  
  it "assigns the passed in name to the new iteration" do
    @project.iterations.first.name.should == "Iteration Foo"
  end
  
  it "assigns the passed in start date to the new iteration" do
    @project.iterations.first.start_date == @today    
  end

  it "assigns the passed in end date to the new iteration" do
    @project.iterations.first.end_date == @tomorrow    
  end
end

describe IterationsController, "user with 'user' privileges requesting create unsuccessfully" do
  fixtures :users, :groups_privileges, :privileges, :groups, :projects, :buckets

  before do
    @user = old_login_as :joe
    @user.has_privilege?(:user).should be_true
    @project = projects(:project1)
    @project.iterations.destroy_all
    @project.iterations.should be_empty

    post( :create, 
          :project_id => @project.id,
          :iteration => { 
            :start_date => '', 
            :end_date => '',
            :name => '' } )
    @project.iterations(true)
  end
  
  it "render the new template" do
    response.should render_template("new")
  end
  
  it "should not add an iteration for the project" do
    @project.iterations.should be_empty
  end
end

describe IterationsController, "user with 'user' privileges requesting update successfully" do
  fixtures :users, :groups_privileges, :privileges, :groups, :projects, :buckets

  before do
    @user = old_login_as :joe
    @user.has_privilege?(:user).should be_true
    @project = projects(:project1)
    @project.iterations.should_not be_empty
    @iteration = @project.iterations.first
  
    @today, @tomorrow = Date.today, Date.today + 1
    put(:update, 
        :project_id => @project.id,
        :id => @iteration.id,
        :iteration => { :name => "HRM" })
    @project.iterations(true)
  end
  
  it "redirects to the created iteration's index page" do
    response.should be_redirect
    path = iteration_path(:project_id=>@project.id, :id=>@iteration.id)
    response.should redirect_to(path)
  end
end

describe IterationsController, "user with 'user' privileges requesting update unsuccessfully" do
  fixtures :users, :groups_privileges, :privileges, :groups, :projects, :buckets

  before do
    @user = old_login_as :joe
    @user.has_privilege?(:user).should be_true
    @project = projects(:project1)
    @project.iterations.should_not be_empty
    @iteration = @project.iterations.first

    put( :update, 
          :project_id => @project.id,
          :id => @iteration.id,
          :iteration => { 
            :start_date => '', 
            :end_date => '',
            :name => '' } )
    @project.iterations(true)
  end
  
  it "render the edit template" do
    response.should render_template("edit")
  end
  
  it "should not update the iteration for the project" do
    @iteration.reload
    @iteration.name.should_not == ''
    @iteration.start_date.should_not == ''
    @iteration.end_date.should_not == ''
  end
end


describe IterationsController, "user with 'user' privileges requesting edit" do
  fixtures :users, :groups_privileges, :privileges, :groups, :projects, :buckets

  before do
    @user = old_login_as :joe
    @user.has_privilege?(:user).should be_true
    @project = projects(:project1)
    @project.iterations.should_not be_empty
    @iteration = @project.iterations.first
  
    get :edit, :project_id => @project.id, :id => @iteration.id
  end
  
  it "renders edit template" do
    response.should be_success
    response.should render_template('edit')
  end

  it "assigns the requested iteration" do
    assigns[:iteration].should == @iteration
  end
end

describe IterationsController, "user with 'user' privileges requesting destroy" do
  fixtures :users, :groups_privileges, :privileges, :groups, :projects, :buckets
  
  before do
    @user = old_login_as :joe
    @user.has_privilege?(:user).should be_true
    @project = projects(:project1)
    @project.iterations.should_not be_empty
    @iteration = @project.iterations.first

    @old_count = Iteration.count
    delete :destroy, :project_id=>@project.id, :id => @iteration.id
  end

  it "destroys an existing iteration" do
    assert_equal @old_count-1, Iteration.count
  end

  it "redirects the user to the iterations index page" do
    assert_redirected_to iterations_path(@project)    
  end
end
