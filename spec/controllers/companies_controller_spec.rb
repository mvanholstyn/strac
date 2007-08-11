require File.dirname(__FILE__) + '/../spec_helper'

describe CompaniesController, "requesting actions without crud_companies privilege" do
  fixtures :companies

  it "redirects to the login page when index is requested" do
    get :index
    response.should redirect_to(login_users_path)
  end

  it "redirects to the login page when show is requested" do
    get :show, :id => 1
    response.should redirect_to(login_users_path)
  end

  it "redirects to the login page when new is requested" do
    get :new
    response.should redirect_to(login_users_path)
  end

  it "redirects to the login page when edit is requested" do
    get :edit, :id=>1
    response.should redirect_to(login_users_path)
  end
  
  it "redirects to the login page when create is requested" do
    post :create
    response.should redirect_to(login_users_path)
  end

  
  it "redirects to the login page when update is requested" do
    put :update, :id=>1
    response.should redirect_to(login_users_path)
  end
  
  it "redirects to the login page when destroy is requested" do
    delete :destroy, :id=>1
    response.should redirect_to(login_users_path)
  end
  
end

describe CompaniesController, "posting to the 'create' action with user and crud_privileges" do
  fixtures :companies, :users, :privileges, :groups_privileges, :groups
  
  before do
    @user = login_as 'crud_companies'
    @user.has_privilege?(:user).should be_true
    @user.has_privilege?(:crud_companies).should be_true
  end

  it "creates a company" do
    old_count = Company.count
    post :create, { :company => { :name=>"JoeCompany" }}
    Company.count.should == old_count+1
    response.should redirect_to(company_path(assigns(:company)))
  end
end

describe CompaniesController, "putting to the 'update' action with user and crud_privileges" do
  fixtures :companies, :users, :privileges, :groups_privileges, :groups
  
  before do
    @user = login_as 'crud_companies'
    @user.has_privilege?(:user).should be_true
    @user.has_privilege?(:crud_companies).should be_true
    @company = companies(:abc_company)
    @company.name.should == "ABC Company"
  end

  it "updates an existing project" do
    put :update, :id => @company.id, :company => { :name=>"foo" }
    assert_redirected_to company_path(assigns(:company))
    @company.reload.name.should == "foo"  
  end
end

describe CompaniesController, "delete to the 'destroy' action with user and crud_privileges" do
  fixtures :companies, :users, :privileges, :groups_privileges, :groups
  
  before do
    @user = login_as 'crud_companies'
    @user.has_privilege?(:user).should be_true
    @user.has_privilege?(:crud_companies).should be_true
    @company = companies(:abc_company)
  end

  it "destroys an existing project" do
    old_count = Company.count
    delete :destroy, :id => @company.id
    assert_equal old_count-1, Company.count
    assert_redirected_to companies_path
  end
end
