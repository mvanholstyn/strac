# == Schema Information
# Schema version: 26
#
# Table name: projects
#
#  id   :integer(11)   not null, primary key
#  name :string(255)   
#

class Project < ActiveRecord::Base
  has_many :time_entries
  has_many :stories
  has_many :activities
  has_many :project_permissions
  has_many_polymorphs :accessors, :through => :project_permissions, :from => [ :companies, :users ]
  has_many :iterations do 
    def find_current
      find :first, :conditions => [ "? BETWEEN start_date AND end_date", Date.today ]
    end
  
    def find_or_build_current
      find_current || build( :name => "Iteration #{size + 1}", :start_date => Date.today, :end_date =>  Date.today + 7 )
    end
  end
end
