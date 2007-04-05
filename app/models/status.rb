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
