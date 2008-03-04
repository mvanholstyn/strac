class BacklogIterationPresenter < PresentationObject
  attr_accessor :stories
  
  def initialize(iteration, stories)
    @stories = stories
    
    delegate :name, :project, :to => iteration
    
    declare :id do
      "backlog"
    end
    
    declare :unique_id do
      'iteration_nil'
    end
  end
end