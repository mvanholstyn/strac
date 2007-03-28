class AffectedObserver < ActiveRecord::Observer
  observe Story
  
  def after_create affected
    create_activity affected, 'created'
  end
  
  def after_update affected
    create_activity affected, 'updated'
  end
  
  def after_destroy affected
    create_activity affected, 'destroyed'
  end
  
  private
  
  def create_activity affected, action
    Activity.create! :actor => User.current_user, :affected => affected, :action => action
  end
end
