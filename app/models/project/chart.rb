class Project::Chart < PresentationObject
  def initialize project
    @project = project
  end
  
  declare :iterations do
    @project.iterations.sort_by{ |iteration| iteration.started_at }
  end
  
  declare :completed_points do
    completed_points = iterations.map{|iteration| iteration.snapshot.completed_points}
    completed_points << @project.completed_points
    completed_points
  end
  
  declare :total_points do
    total_points = iterations.map{|iteration| iteration.snapshot.total_points}
    total_points << @project.total_points
    total_points
  end
  
  declare :remaining_points do
    remaining_points = iterations.map{|iteration| iteration.snapshot.remaining_points}
    remaining_points << @project.remaining_points
    remaining_points
  end
  
  declare :show_trends? do
    iterations.size > 1
  end
  
  declare :trends do
    iteration_count = iterations.size

    xvalues = (1..iteration_count).to_a
    regression = LinearRegression.new xvalues, remaining_points.values_at(*xvalues)
    (0..iteration_count).inject([]) {|values, i| values << regression[i] }
  end
  
  declare :ylabels do
    step_count = 6
    min = 0
    max = (completed_points + total_points + remaining_points).map(&:to_i).max
    step = [max / step_count.to_f, 1].max
    ylabels = []
    min.step(max, step) { |f| ylabels << f.round }
    ylabels
  end
  
  declare :xlabels do
    iterations.map{ |e| iterations.index(e) } + ["current"]
  end
  
  declare :remaining_points_trend_color do
    '551a8b'
  end
  
  declare :completed_points_color do
    '00FF00'
  end
  
  declare :total_points_color do
    '0000FF'
  end
  
  declare :remaining_points_color do
    'a020f0'
  end
  
  declare :data do
    data = [
      total_points, 
      completed_points, 
      remaining_points
    ]
    
    data << trends if show_trends?
    data
  end
  
  declare :colors do
    colors = [
      total_points_color,         
      completed_points_color,            
      remaining_points_color
    ]
    colors << remaining_points_trend_color if show_trends?
    colors
  end
  
  declare :legend do
    legend = ["Total Points", "Total Points Completed", "Points Remaining"]
    legend << "Points Remaining Trend" if show_trends?
    legend
  end
  
end