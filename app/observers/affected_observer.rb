class AffectedObserver < ActiveRecord::Observer  
  attr_accessor :cache
  
  class_inheritable_accessor :messages
  self.messages = []

  def initialize *args, &blk
    super *args, &blk
    self.cache = {}
  end
  
  def self.message( message, options )
    self.messages << [ message, options ]
  end
  
  def after_create( object )
    self.class.messages.each do |(message,options)|      
      if options[:created] 
        message = eval message
        project = options[:project] ? options[:project].call( object ) : object.project
        object = options[:object] ? options[:object].call( object ) : object
        create_activity( project, object, message )
      end
    end    
  end
  
  def after_destroy( object )
    self.class.messages.each do |(message,options)|      
      if options[:destroyed] 
        message = eval message
        project = options[:project] ? options[:project].call( object ) : object.project
        object = options[:object] ? options[:object].call( object ) : object
        create_activity( project, object, message )
      end
    end    
  end
  
  def after_update( object )
    self.class.messages.each do |(message,options)|    
      next unless options[:updated]
      differences = cache[object]
        
      options[:updated].each do |field|
        if differences[field]
          create = if options[:nil] == false
            true if differences[field].first
          elsif options[:nil] == true 
            true if differences[field].first.nil?
          else
            true
          end
          
          if create
            message = eval message
            project = options[:project] ? options[:project].call( object ) : object.project
            object = options[:object] ? options[:object].call( object ) : object
            create_activity( project, object, message )
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
  
  def create_activity project, object, message
    if User.current_user
      Activity.create! :actor => User.current_user, :action => message, :project => project, :affected => object
    end
  end
end
