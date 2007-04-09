class AffectedObserver < ActiveRecord::Observer
  observe Story
  
  attr_accessor :cache
  
  def initialize *args, &blk
    super *args, &blk
    self.cache = {}
  end
  
  def after_create direct_object
    create_activity direct_object, 'created'
  end
  
  def before_update direct_object
    puts "=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+"
    cache[direct_object] = direct_object.differences
  end
  
  def after_update direct_object
    puts "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
    puts cache[direct_object].inspect
    
    create_activity direct_object, 'updated points' if cache[direct_object][:points]
    create_activity direct_object, "assigned to #{direct_object.responsible_party.name}" if cache[direct_object][:responsible_party_id] and cache[direct_object][:responsible_party_id].first
    if cache[direct_object][:responsible_party_id] and not cache[direct_object][:responsible_party_id].first
      type = cache[direct_object][:responsible_party_type]
      type = type ? type.last : direct_object.responsible_party_type
      responsible_party = Object.const_get( type ).find( cache[direct_object][:responsible_party_id].last )
      create_activity direct_object, "released from #{responsible_party.name}"
    end
    create_activity direct_object, "marked as #{direct_object.status.name}" if cache[direct_object][:status_id]
    create_activity direct_object, "updated priority to #{direct_object.priority.name}" if cache[direct_object][:priority_id]
    create_activity direct_object, "moved to #{direct_object.iteration.name}" if cache[direct_object][:iteration_id]
    cache[direct_object] = nil
  end
  
  def after_destroy direct_object
    #create_activity direct_object, 'destroyed'
    direct_object.activities.map{ |a| a.destroy }
  end
  
  private
  
  def create_activity direct_object, action
    Activity.create! :actor => User.current_user, :direct_object => direct_object, :action => action, :project => direct_object.project
  end
end
