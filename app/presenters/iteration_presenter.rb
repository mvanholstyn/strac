class IterationPresenter < PresentationObject
  def initialize(iteration)
    delegate :id, :start_date, :end_date, :name, 
             :project, :budget, :points_completed, 
             :points_remaining, :display_name, :stories, :to => iteration

    declare :unique_id do
      iteration.new_record? ? "iteration_nil" : "iteration_#{iteration.id}"
    end
  end
end