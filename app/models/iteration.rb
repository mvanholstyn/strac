class Iteration < ActiveRecord::Base
  has_many :stories, :order => :position
  belongs_to :project

  validates_presence_of :start_date, :end_date, :project

  def name
    start_date.strftime( "%Y-%m-%d" ) + " thru " + end_date.strftime( "%Y-%m-%d" )
  end
end
