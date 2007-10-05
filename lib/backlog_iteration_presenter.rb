class BacklogIterationPresenter < PresentationObject
  def initialize(iteration)
    delegate :stories, :project, :to => iteration
    declare :unique_id do
      'iteration_nil'
    end
  end
end