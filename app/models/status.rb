# == Schema Information
# Schema version: 41
#
# Table name: statuses
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   
#  color      :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#

class Status < ActiveRecord::Base
  
  validates_presence_of :color

  class << self
    def defined 
      @defined ||= Status.find( :first, :conditions=>{:name=>"defined"} ) || 
        Status.create!(:name => "defined", :color => "blue")
    end
    
    def in_progress
      @in_progress ||= Status.find( :first, :conditions=>{:name=>"in progress"} ) || 
        Status.create!(:name => "in progress", :color => "yellow")
    end
    
    def complete
      @complete ||= Status.find( :first, :conditions=>{:name=>"complete"} ) || 
        Status.create!(:name => "complete", :color => "green" )
    end
    
    def rejected
      @rejected ||= Status.find( :first, :conditions=>{:name=>"rejected"} ) || 
        Status.create!(:name => "rejected", :color => "black")
    end
    
    def blocked
      @blocked ||= Status.find( :first, :conditions=>{:name=>"blocked"} ) || 
        Status.create!(:name => "blocked", :color => "blocked")
    end
    
    def statuses
      [ defined, in_progress, complete, rejected, blocked ]
    end
  end
    
end
