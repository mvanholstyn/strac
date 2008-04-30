steps_for :a_user_viewing_project_stats_when_there_are_complete_and_incomplete_estimated_stories do
  Given "a project exists with both complete and incomplete stories" do
    destroy_stories_and_iterations
    @project = Generate.project
    @stories = generate_estimated_stories_for_project @project
    @completed_stories = make_stories_completed @stories[0..1]
    @incomplete_stories = @stories[2..-1]    
  end
end