class Project < ActiveRecord::Base
  has_many :stories, :order => "iteration_id, position" do
    def without_iteration
      find( :all, :conditions => { :iteration_id => nil }, :include => :tags )
    end
  end

  has_many :iterations, :order => 'start_date, end_date'
end
