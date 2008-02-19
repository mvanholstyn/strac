require File.dirname(__FILE__) + '/../spec_helper'

class RemoveCompaniesSpec # scopes the redefined model inside this to prevent it from breaking other tests
  describe "042RemoveCompanies" do
    class ProjectPermission < ActiveRecord::Base ; end
  
    before do
      drop_all_tables
      migrate :version => 41

      10.times do |i|
        ProjectPermission.create! :accessor_type => "Company", :accessor_id => i
        ProjectPermission.create! :accessor_type => "User", :accessor_id => i
      end
    end
  
    after do
      drop_all_tables
      migrate     
    end
  
    it "removes project permissions which were assigned to companies" do
      ProjectPermission.count(:conditions => "accessor_type = 'Company'").should == 10
      migrate :version => 42
      ProjectPermission.count(:conditions => "accessor_type = 'Company'").should == 0
    end

    it "does not remove project permissions assigned to other types of accessors" do
      ProjectPermission.count(:conditions => "accessor_type = 'User'").should == 10
      migrate :version => 42
      ProjectPermission.count(:conditions => "accessor_type = 'User'").should == 10
    end
  end
end