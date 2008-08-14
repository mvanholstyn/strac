steps_for :a_user_viewing_the_average_velocity_after_completing_several_iterations do
  Given /the user completes an iteration worth (\d+) points/ do |num|
    @iteration_count ||= 0
    iteration = Generate.iteration :name => "iteration #{@iteration_count+=1}", :project => @project, :started_at => 18.weeks.ago, :ended_at => 17.weeks.ago
    story = Generate.story :bucket => iteration, :points => num, :status => Status.complete, :project => @project
  end
  Given /the user completes another iteration worth (\d+) points/ do |num|
    last_iteration = Iteration.find(:first, :order => "id desc")
    started_at = last_iteration.ended_at + 1.day
    ended_at = started_at  + 1.week
    iteration = Generate.iteration :name => "iteration #{@iteration_count+=1}", :project => @project, :started_at => started_at, :ended_at => ended_at
    Generate.story :bucket => iteration, :points => num, :status => Status.complete, :project => @project
  end    
end