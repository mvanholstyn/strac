class Iteration < ActiveRecord::Base
  has_many :stories
  belongs_to :project

  validates_presence_of :start_date, :end_date, :project_id
  
  def display_name
    if name.blank?
      start_date.strftime( "%Y-%m-%d" ) + " through " + end_date.strftime( "%Y-%m-%d" )
    else
      "#{name} (#{start_date.strftime( "%Y-%m-%d" ) + " through " + end_date.strftime( "%Y-%m-%d" )})"
    end
  end

  def self.find_current
    find :first, :conditions => [ "? BETWEEN start_date AND end_date", Date.today ]
  end
end
