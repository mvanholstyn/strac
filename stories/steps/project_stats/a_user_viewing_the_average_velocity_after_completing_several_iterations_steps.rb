steps_for :a_user_viewing_the_average_velocity_after_completing_several_iterations do
  Given /the user completes an iteration worth (\d+) points/ do |num|
    @iteration_count ||= 0
    iteration = Generate.iteration :name => "iteration #{@iteration_count+=1}", :project => @project, :start_date => 18.weeks.ago, :end_date => 17.weeks.ago
    Generate.story :bucket => iteration, :points => num, :status => Status.complete
  end
  Given /the user completes another iteration worth (\d+) points/ do |num|
    last_iteration = Iteration.find(:first, :order => "id desc")
    start_date = last_iteration.end_date + 1.day
    end_date = start_date  + 1.week
    iteration = Generate.iteration :name => "iteration #{@iteration_count+=1}", :project => @project, :start_date => start_date, :end_date => end_date
    Generate.story :bucket => iteration, :points => num, :status => Status.complete
  end    
end