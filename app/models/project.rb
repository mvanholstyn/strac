class Project < ActiveRecord::Base
  has_many :stories do
    def without_iteration
      find( :all, :conditions => { :iteration_id => nil } )
    end
  end

  has_many :iterations do
    def ordered
      find :all, :order => 'start_date, end_date'
    end
  end
end
