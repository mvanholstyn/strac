steps_for :a_user_viewing_project_stats_when_there_are_no_stories_or_iterations do
  Given "there are no iterations or stories which belong to that project" do
    destroy_stories_and_iterations
    @project = Generate.project
  end
end