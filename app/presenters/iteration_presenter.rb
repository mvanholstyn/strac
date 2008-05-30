class IterationPresenter < PresentationObject
  attr_accessor :stories

  def initialize(iteration, stories)
    @stories = stories
    
    delegate :id, :started_at, :ended_at, :name, 
             :project, :budget, :points_completed, 
             :points_remaining, :display_name, :to => iteration

    declare :unique_id do
      iteration.new_record? ? "iteration_nil" : "iteration_#{iteration.id}"
    end
  end
end