class BacklogIterationPresenter < PresentationObject
  def initialize(iteration)
    delegate :name, :project, :to => iteration
    
    declare :id do
      "backlog"
    end
    
    declare :unique_id do
      'iteration_nil'
    end
    
    declare :show? do
      true
    end
    
    declare :stories do
      project.backlog_stories
    end
  end
end