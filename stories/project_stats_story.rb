require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Stats", %|
  As a user 
  I should be able to view project statistics
  so that I can view important information about my project quickly.|, 
  :type => RailsStory do

  Scenario "a project with no stories or iterations" do
    Given "there are no iterations or stories which belong to that project" do
      Story.destroy_all
      Iteration.destroy_all
    end
    When "the user views the project summary" do
      a_user_viewing_a_project
    end
    Then "they will see zero total points for the project" do
      see_zero_total_points
    end
    And "they will see zero completed points for the project" do
      see_zero_completed_points
    end
    And "they will see zero remaining points for the project" do
      see_zero_remaining_points
    end
    And "they will see zero as the average velocity for the project" do
      see_zero_average_velocity
    end
    And "they will zero estimated remaining iterations for the project" do
      see_zero_estimated_remaining_iterations
    end
    And "they will see today the estimated completion date for the project" do
      see_today_as_the_estimated_completion_date
    end
    
    Given "the user logs out (2)" do
      reset! 
    end
    And "there are incomplete, estimated stories added to the project (2)" do
      @stories = [
        Generate.story(:summary => "story 1", :points => "1", :project => @project),
        Generate.story(:summary => "story 2", :points => "2", :project => @project),
        Generate.story(:summary => "story 3", :points => "4", :project => @project),
        Generate.story(:summary => "story 4", :points => "0", :project => @project),
      ]
    end
    When "the user views the project summary (2)" do
      a_user_viewing_a_project :project => @project
    end
    Then "they will see the sum of total points for the project (2)" do
      see_total_points @stories.sum(&:points)
    end
    And "they will see zero completed points for the project (2)" do
      see_completed_points 0
    end
    And "they will see remaining points for the project (2)" do
      see_remaining_points @stories.sum(&:points)
    end
    And "they will see zero as the average velocity for the project (2)" do
      see_zero_average_velocity
    end
    And "they will zero estimated remaining iterations for the project (2)" do
      see_zero_estimated_remaining_iterations
    end
    And "they will see today the estimated completion date for the project (2)" do
      see_today_as_the_estimated_completion_date
    end

    Given "the user logs out" do
      reset! 
    end
    And "some of the estimated stories are completed" do
      @completed_stories = @stories[0..1]
      @incomplete_stories = @stories[2..-1]
      @completed_stories.each do |story|
        story.update_attribute :status, Status.complete
      end
    end
    When "the user views the project summary (3)" do
      a_user_viewing_a_project :project => @project
    end
    Then "they will see the sum of total points for the project (3)" do
      see_total_points @stories.sum(&:points)
    end
    And "they will the correct number of completed points for the project (3)" do
      see_completed_points @completed_stories.sum(&:points)
    end
    And "they will see the correct number of remaining points for the project (3)" do
      see_remaining_points @incomplete_stories.sum(&:points)
    end
    And "they will see zero as the average velocity for the project (3)" do
      see_zero_average_velocity
    end
    And "they will zero estimated remaining iterations for the project (3)" do
      see_zero_estimated_remaining_iterations
    end
    And "they will see today the estimated completion date for the project (3)" do
      see_today_as_the_estimated_completion_date
    end

    Given "the user logs out (4)" do
      reset! 
    end
    And "the completed stories are added to an completed iteration(4)" do
      @iteration = Generate.iteration("Iteration 1", 
        :project => @project, 
        :start_date => 1.week.ago, 
        :end_date => Time.now.yesterday)
      @completed_stories.each do |story|
        story.update_attribute :bucket, @iteration
      end
    end
    When "the user views the project summary (4)" do
      a_user_viewing_a_project :project => @project
    end
    Then "they will see the sum of total points for the project (4)" do
      see_total_points @stories.sum(&:points)
    end
    And "they will the correct number of completed points for the project (4)" do
      see_completed_points @completed_stories.sum(&:points)
    end
    And "they will see the correct number of remaining points for the project (4)" do
      @remaining_points = @incomplete_stories.sum(&:points)
      see_remaining_points @remaining_points
    end
    And "they will see the sum of completed points for the iteration as the average velocity for the project (4)" do
      @average_velocity = @completed_stories.sum(&:points)
      see_average_velocity @average_velocity
    end
    And "they will see the correct number of estimated remaining iterations for the project (4)" do
      @remaining_iterations = @stories.sum(&:points) / @completed_stories.sum(&:points) 
      see_estimated_remaining_iterations @remaining_iterations
    end
    And "they will see the correct estimated completion date based on a 1 week iteration" do
      @remaining_iterations = @remaining_points.to_f / @average_velocity.to_f
      date = Date.today + @remaining_iterations * 7 
      see_estimated_completion_date date
    end
  end
    
  def see_zero_total_points
    see_total_points 0
  end
  
  def see_total_points(points)
    see_project_summary do
      assert_select '.total_points', points.to_s.to_regexp
    end
  end
  
  def see_zero_completed_points
    see_completed_points 0
  end
  
  def see_completed_points(points)
    see_project_summary do
      assert_select '.completed_points', points.to_s.to_regexp
    end    
  end
    
  def see_zero_remaining_points
    see_remaining_points 0
  end
  
  def see_remaining_points(points)
    see_project_summary do
      assert_select '.remaining_points', points.to_s.to_regexp
    end
  end
  
  def see_zero_average_velocity
    see_average_velocity 0
  end
  
  def see_average_velocity(velocity)
    see_project_summary do
      assert_select '.average_velocity', velocity.to_s.to_regexp
    end            
  end
  
  def see_zero_estimated_remaining_iterations
    see_estimated_remaining_iterations 0
  end
  
  def see_estimated_remaining_iterations(remaining_iterations)
    see_project_summary do
      assert_select '.estimated_remaining_iterations', remaining_iterations.to_s.to_regexp
    end                
  end
  
  def see_today_as_the_estimated_completion_date
    see_estimated_completion_date Time.now
  end
  
  def see_estimated_completion_date(date)
    see_project_summary do
      assert_select '.estimated_completion_date', date.strftime("%Y-%m-%d").to_regexp
    end    
  end
end