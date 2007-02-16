class Iteration < ActiveRecord::Base
  has_many :stories

  validates_presence_of :start_date, :end_date

  def name
    start_date.strftime( "%Y-%m-%d" ) + " thru " + end_date.strftime( "%Y-%m-%d" )
  end
end
