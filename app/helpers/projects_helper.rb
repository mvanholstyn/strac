module ProjectsHelper
  def current_iteration_name
    current = @project.iterations.current
    current ? current.name : "No Iterations Exist"
  end
end