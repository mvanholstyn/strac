class IterationsPresenter < PresentationObject
  include Enumerable
  
  def initialize(iterations, backlog_iteration=nil)
    declare :iterations do
      iterations.map{ |iter| IterationPresenter.new(iter)}
    end

    declare :backlog do
      BacklogIterationPresenter.new(backlog_iteration)
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