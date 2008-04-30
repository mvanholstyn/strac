steps_for :a_user_viewing_project_stats_when_there_are_incomplete_estimated_stories do
  Given "there are incomplete, estimated stories added to the project" do
    destroy_stories_and_iterations
    @project = Generate.project
    @stories = generate_estimated_stories_for_project @project
  end
end