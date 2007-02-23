class Project < ActiveRecord::Base
  has_many :stories do
    def without_iteration options = {}
      find( :all, :conditions => { :iteration_id => nil } )
    end
  end
  has_many :iterations, :order => 'start_date, end_date'
end
