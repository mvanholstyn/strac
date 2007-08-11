require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectPermission do
  before(:each) do
    @project_permission = ProjectPermission.new
  end

  it "should be valid" do
    @project_permission.should be_valid
  end

  describe "User with project permissions" do
    fixtures :users, :projects, :project_permissions, :companies
    
    before(:each) do
      @user = users(:joe)
      @user.company.should be_nil
    end
      
    it "should find the project that a user has permissions on given the project" do
      project = ProjectPermission.find_project_for_user projects(:project1), @user
      project.should == projects(:project1)
    end
      
    it "should find the project that a user has permissions on given the project" do
      project = ProjectPermission.find_project_for_user projects(:project2), @user
      project.should == projects(:project2)
    end
        
    it "should find all projects that the user has permissions on" do
      projects = ProjectPermission.find_all_projects_for_user @user
      projects.size.should == 2
      projects.should include(projects(:project1))
      projects.should include(projects(:project1))
    end
  end
  
  describe "User with project permissions through company" do
    fixtures :users, :projects, :project_permissions, :companies
    
    before(:each) do
      @user = users(:stan)
      @user.company.should == companies(:abc_company)
    end
    
    it "should find the project that a user has permissions on given the project" do
      project = ProjectPermission.find_project_for_user projects(:project1), @user
      project.should == projects(:project1)
    end
    
    it "should find projects based that the user has permissions on through his/her company" do
      projects = ProjectPermission.find_all_projects_for_user @user
      projects.size.should == 1
      projects.first.should == projects(:project1)
    end
  end

  describe "User without project permissions" do
    fixtures :users, :projects, :project_permissions, :companies
    
    before(:each) do
      @user = users(:carl)
      @user.company.should == companies(:carls_company)
    end
    
    it "should return nil when no project permission is found for a given project" do
      project = ProjectPermission.find_project_for_user projects(:project1), @user
      project.should be_nil
    end
 
    it "should an array when no project permission is found for a given user when searching all projects" do
      projects = ProjectPermission.find_all_projects_for_user @user
      projects.should be_empty
    end 
    
  end
end
