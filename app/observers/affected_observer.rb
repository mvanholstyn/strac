class AffectedObserver < ActiveRecord::Observer
  observe Story
  
  attr_accessor :cache
  
  def initialize *args, &blk
    super *args, &blk
    self.cache = {}
  end
  
  def after_create direct_object
    create_activity direct_object.project, "created S#{direct_object.id}"
  end
  
  def before_update direct_object
    cache[direct_object] = direct_object.differences
  end
  
  def after_update direct_object
    create_activity direct_object.project, "updated points for S#{direct_object.id}" if cache[direct_object][:points]
    create_activity direct_object.project, "assigned S#{direct_object.id} to #{direct_object.responsible_party_type.upcase}#{direct_object.responsible_party_id}" if cache[direct_object][:responsible_party_id] and cache[direct_object][:responsible_party_id].first
    if cache[direct_object][:responsible_party_id] and not cache[direct_object][:responsible_party_id].first
      type = cache[direct_object][:responsible_party_type]
      create_activity direct_object.project, "released S#{direct_object.id} from #{type.upcase}#{cache[direct_object][:responsible_party_id].last}"
    end
    create_activity direct_object.project, "marked S#{direct_object.id} as STATUS#{direct_object.status_id}" if cache[direct_object][:status_id]
    create_activity direct_object.project, "marked S#{direct_object.id} as PRIORITY#{direct_object.priority_id} priority    " if cache[direct_object][:priority_id]
    create_activity direct_object.project, "moved S#{direct_object.id} to I#{direct_object.iteration_id}" if cache[direct_object][:iteration_id]
    if cache[direct_object][:sumamry] or cache[direct_object][:description] or cache[direct_object][:tag]
      create_activity direct_object.project, "updated S#{direct_object.id}"
    end
    cache[direct_object] = nil
  end
  
  def after_destroy direct_object
    #create_activity direct_object, 'destroyed'
    direct_object.activities.map{ |a| a.destroy }
  end
  
  private
  
  def create_activity project, message
    Activity.create! :actor => User.current_user, :action => message, :project => project
  end
end
