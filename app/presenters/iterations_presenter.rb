class IterationsPresenter < PresentationObject
  include Enumerable
  
  def initialize(opts={})
    raise ArgumentError.new("Requires :stories") unless opts[:stories]
    orig_stories, orig_project = opts[:stories], opts[:project]
    
    declare :iterations do
      orig_stories.group_by(&:bucket).map do |iteration, stories|
        if iteration
          IterationPresenter.new(iteration, stories)
        end
      end.compact.sort_by(&:started_at)
    end

    declare :backlog do
      iteration, stories = orig_stories.group_by(&:bucket).detect do |iteration, stories|
        iteration.nil?
      end
      BacklogIterationPresenter.new(project.iterations.backlog, stories || [])
    end
    
    declare :project do
      orig_project
    end
  end
  
  def each
    iterations.each{ |iter| yield iter }
  end
end