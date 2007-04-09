# == Schema Information
# Schema version: 27
#
# Table name: iterations
#
#  id         :integer(11)   not null, primary key
#  start_date :date          
#  end_date   :date          
#  project_id :integer(11)   
#  name       :string(255)   
#  budget     :integer(11)   default(0)
#

class Iteration < ActiveRecord::Base
  has_many :stories
  belongs_to :project

  validates_presence_of :start_date, :end_date, :project_id, :name
  validate :validate_iterations_do_not_overlap
  validate :validate_start_date_is_before_end_date
  
  def points_completed
    Story.sum( :points, :conditions=>{:iteration_id=>id,:status_id=>Status.complete.id} ) || 0
  end
  
  def points_remaining
    budget - points_completed
  end
  
  def display_name
    if name.blank?
      start_date.strftime( "%Y-%m-%d" ) + " through " + end_date.strftime( "%Y-%m-%d" )
    else
      "#{name} (#{start_date.strftime( "%Y-%m-%d" ) + " through " + end_date.strftime( "%Y-%m-%d" )})"
    end
  end
  
  private
  
  def validate_iterations_do_not_overlap
    iterations = Iteration.count( :all, :conditions => [ "id #{id ? "!=" : "IS NOT"} ? AND project_id = ? " <<
      "AND ( ? BETWEEN start_date AND end_date OR ? BETWEEN start_date AND end_date )", 
      id, project_id, start_date, end_date ] )
    
    if not iterations.zero?
      errors.add_to_base "Iterations cannot overlap"
      return false
    end
    
    true
  end
  
  def validate_start_date_is_before_end_date
    if start_date and end_date
      if end_date <= start_date
        errors.add_to_base "start date must be after end date"
        return false
      end
    end
  
    true
  end
end
