# == Schema Information
# Schema version: 30
#
# Table name: statuses
#
#  id    :integer(11)   not null, primary key
#  name  :string(255)   
#  color :string(255)   
#

class Status < ActiveRecord::Base
  
  validates_presence_of :color
  

  class << self
    def defined 
      Status.find( :first, :conditions=>{:name=>"defined"} )
    end
    
    def in_progress
      Status.find( :first, :conditions=>{:name=>"in progress"} )
    end
    
    def complete
      Status.find( :first, :conditions=>{:name=>"complete"} )
    end
    
    def rejected
      Status.find( :first, :conditions=>{:name=>"rejected"} )
    end
    
    def blocked
      Status.find( :first, :conditions=>{:name=>"blocked"} )
    end
  end
  
end
