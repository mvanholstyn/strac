class IterationsPresenter < PresentationObject
  include Enumerable
  
  def initialize(opts={})
    raise ArgumentError.new("Requires :iteration") unless opts[:iterations]
    orig_iterations, orig_backlog, orig_project = opts[:iterations], opts[:backlog], opts[:project]
    
    declare :iterations do
      orig_iterations.map{ |iter| IterationPresenter.new(iter)}
    end

    declare :backlog do
      orig_backlog ? BacklogIterationPresenter.new(orig_backlog) : nil
    end
    
    declare :project do
      orig_project
    end
    
    declare :containment_ids do
      ([backlog] + iterations).map{ |e| e.unique_id }
    end
  end
  
  def each
    iterations.each{ |iter| yield iter }
  end
  
  def each_with_backlog
    ([backlog] + iterations).each do |iter| 
      yield iter
    end
  end
end