# == Schema Information
# Schema version: 27
#
# Table name: projects
#
#  id   :integer(11)   not null, primary key
#  name :string(255)   
#

class Project < ActiveRecord::Base
  has_many :time_entries
  has_many :stories
  has_many :activities
  has_many :project_permissions, :dependent => :destroy
  has_many_polymorphs :accessors, :through => :project_permissions, :from => [ :companies, :users ]
  has_many :iterations do 
    def find_current
      find :first, :conditions => [ "? BETWEEN start_date AND end_date", Date.today ]
    end
  
    def find_or_build_current
      find_current || build( :name => "Iteration #{size + 1}", :start_date => Date.today, :end_date =>  Date.today + 7 )
    end
  end
  
  def total_points
    stories.sum( :points, :conditions => [ "status_id NOT IN (?)", Status.find( :all, :conditions => [ "name IN (?)", [ "rejected" ] ] ).map( &:id) ] )
  end
  
  def completed_points
    stories.sum( :points, :conditions => [ "status_id IN (?)", Status.find( :all, :conditions => [ "name IN (?)", [ "complete" ] ] ).map( &:id) ] )
  end
  
  def remaining_points
    stories.sum( :points, :conditions => [ "status_id NOT IN (?)", Status.find( :all, :conditions => [ "name IN (?)", [ "complete", "rejected" ] ] ).map( &:id) ] )
  end
  
  def average_velocity
    velocity = iterations.inject( 0 ) do |sum,iteration|
      sum + ( iteration.stories.sum( :points, :conditions => [ "status_id IN (?)", Status.find( :all, :conditions => [ "name IN (?)", [ "complete", "rejected" ] ] ).map( &:id) ] ) || 0 )
    end
    iterations.empty? ? 0 : velocity.to_f / iterations.size.to_f
  end
  
  def estimated_remaining_iterations
    average_velocity.zero? ? 0 : remaining_points.to_f / average_velocity.to_f
  end
  
  def estimated_completion_date
    Date.today + estimated_remaining_iterations * 7
  end
end
