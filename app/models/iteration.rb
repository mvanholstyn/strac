# == Schema Information
# Schema version: 41
#
# Table name: iterations
#
#  id         :integer(11)   not null, primary key
#  started_at :date          
#  ended_at   :date          
#  project_id :integer(11)   
#  name       :string(255)   
#  budget     :integer(11)   default(0)
#  created_at :datetime      
#  updated_at :datetime      
#

class Iteration < Bucket

  validates_presence_of :started_at
  validate :validate_iterations_do_not_overlap
  validate :validate_started_at_is_before_ended_at
  
  def points_before_iteration
    Story.sum( :points, 
      :conditions => ["created_at < :started_at", { :started_at => self.started_at } ] ) || 0
  end
  
  def points_completed
    Story.sum( :points, :conditions => { :bucket_id => id,:status_id => Status.complete.id } ) || 0
  end
  
  def points_remaining
    total_points - points_completed
  end

  def total_points
    Story.sum( :points, :conditions => { :bucket_id => id } ) || 0
  end
  
  def display_name
    started = started_at.strftime( "%Y-%m-%d" )
    ended = ended_at.blank? ? "Now" : ended_at.strftime( "%Y-%m-%d" )
    msg = "#{started} through #{ended}"
    
    if name.blank?
      msg
    else
      "#{name} (#{msg})"
    end
  end

  private
  
  def validate_iterations_do_not_overlap
    iterations = Iteration.count( :all, :conditions => [ "id #{id ? "!=" : "IS NOT"} ? AND project_id = ? " <<
      "AND ( ? BETWEEN started_at AND ended_at OR ? BETWEEN started_at AND ended_at )", 
      id, project_id, started_at, ended_at ] )
    
    if not iterations.zero?
      errors.add_to_base "Iterations cannot overlap"
      return false
    end
    
    true
  end
  
  def validate_started_at_is_before_ended_at
    if started_at and ended_at
      if ended_at <= started_at
        errors.add_to_base "start date must be before end date"
        return false
      end
    end
  
    true
  end
  
end
