class Iteration < ActiveRecord::Base
  has_many :stories do
    def ordered
      find :all, :order => :position
    end
  end
  belongs_to :project

  validates_presence_of :start_date, :end_date, :project_id

  def name
    start_date.strftime( "%Y-%m-%d" ) + " through " + end_date.strftime( "%Y-%m-%d" )
  end
end
