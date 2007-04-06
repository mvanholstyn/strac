class AffectedObserver < ActiveRecord::Observer
  observe Story
  
  def after_create direct_object
    create_activity direct_object, 'created'
  end
  
  def after_update direct_object
    create_activity direct_object, 'updated'
  end
  
  def after_destroy direct_object
    create_activity direct_object, 'destroyed'
  end
  
  private
  
  def create_activity direct_object, action
    Activity.create! :actor => User.current_user, :direct_object => direct_object, :action => action, :project => direct_object.project
  end
end
