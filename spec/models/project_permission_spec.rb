require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectPermission, "with no specified attributes" do
  before do
    @project_permission = ProjectPermission.new
  end
  
  it "should be valid" do
    @project_permission.should be_valid
  end
end

describe ProjectPermission, "User that has permissions on two projects" do
  before do
    @group = Generate.group(:name => "GroupA")
    @user = Generate.user(:email_address => "jabba the hut", :group => @group)
    @projects = [ Generate.project(:name => "ProjectA"), Generate.project(:name => "ProjectB") ]
    @projects.each do |project|
      project.users << @user
    end
  end
      
  it "finds the first project that a user has permissions on given the project" do
    project = ProjectPermission.find_project_for_user @projects.first, @user
    project.should == @projects.first
  end
    
  it "finds the second project that a user has permissions on given the project" do
    project = ProjectPermission.find_project_for_user @projects.last, @user
    project.should == @projects.last
  end
      
  it "finds all projects that the user has permissions on" do
    projects = ProjectPermission.find_all_projects_for_user @user
    projects.should == @projects
  end
end

describe ProjectPermission, "User without project permissions" do
  before do
    @group = Generate.group(:name => "GroupA")
    @user = Generate.user(:email_address => "jabba the hut", :group => @group)
    @projects = [ Generate.project(:name => "ProjectA"), Generate.project(:name => "ProjectB") ]
  end
  
  it "should return nil when no project permission is found for a given project" do
    ProjectPermission.find_project_for_user( @projects.first, @user ).should be_nil
    ProjectPermission.find_project_for_user( @projects.last, @user ).should be_nil
  end
 
  it "should return an empty array when looking for projects the user has permissions on" do
    projects = ProjectPermission.find_all_projects_for_user @user
    projects.should be_empty
  end 
end
