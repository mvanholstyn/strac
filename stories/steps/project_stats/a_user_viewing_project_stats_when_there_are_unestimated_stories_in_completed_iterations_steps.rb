steps_for :a_user_viewing_project_stats_when_there_are_unestimated_stories_in_completed_iterations do
  Given "there is a project with a completed iteration where none of its stories were estimated" do
    destroy_stories_and_iterations
    @project = Generate.project
    @iteration = Generate.iteration :name => "already completed", :project => @project, :started_at => 1.week.ago, :ended_at => 1.day.ago
    @stories = generate_unestimated_stories_for_project @project
    move_stories_to_iteration @stories, @iteration
  end 
end