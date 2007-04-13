class AffectedObserver < ActiveRecord::Observer  
  attr_accessor :cache
  
  def self.message( message, options )
    self.messages << [ message, options ]
  end
  
  def self.messages ; @messages ||= [] ; end  
  
  def after_create( object )
    messages.each do |(message,options)|      
      if options[:created] 
        message = eval message
        create_activity( object.project, message )
      end
    end    
  end
  
  def after_destroy( object )
    messages.each do |(message,options)|      
      if options[:destroyed] 
        message = eval message
        create_activity( object.project, message )
      end
    end    
  end
  
  def after_update( object )
    messages.each do |(message,options)|    
      next unless options[:updated]
      differences = cache[object]
        
      options[:updated].each do |field|
        if cache[object][field]
          create = if options[:nil] == false
            true if cache[object][field].first
          elsif options[:nil] == true 
            true if cache[object][field].first.nil?
          else
            true
          end
          
          if create
            message = eval message
            create_activity( object.project, message )
            break
          end
        end
      end
    end
    cache[object] = nil
  end
 
  def before_update object
    cache[object] = object.differences
  end
  
  def initialize *args, &blk
    super *args, &blk
    self.cache = {}
  end
  
  
  private
  
  def create_activity project, message
    Activity.create! :actor => User.current_user, :action => message, :project => project
  end
  
  def messages 
    self.class.messages
  end
  

end
