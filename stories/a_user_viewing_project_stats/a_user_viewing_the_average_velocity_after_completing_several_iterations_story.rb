require File.expand_path(File.dirname(__FILE__) + "/helper")

Story "Project Stats", %|
  As a user 
  I should be able to view project statistics
  so that I can view important information about my project quickly.|, 
  :type => RailsStory do
  extend ProjectStatsStoryHelper

  Scenario "a user complete several iterations and watches the average velocity (0)" do
    Given "there is a project with no stories or iterations" do
      destroy_stories_and_iterations
      @project = Generate.project    
    end
    When "the user views the project summary (0)" do
      a_user_viewing_a_project :project => @project      
    end
    Then "they see the average velocity is 0 (0)" do
      see_zero_average_velocity
    end
    
    Given "the user completes an iteration worth 10 points (1)" do
      iteration = Generate.iteration "iteration 1", :project => @project, :start_date => 18.weeks.ago, :end_date => 17.weeks.ago
      Generate.story :bucket => iteration, :points => 10, :status => Status.complete
    end
    When "the user views the project summary (1)" do
      click_logout_link
      a_user_viewing_a_project :project => @project      
    end 
    Then "they see the average velocity is 10 (1)" do
      see_average_velocity 10
    end
    
    Given "the user completes a second iteration worth 10 points (2)" do
      iteration = Generate.iteration "iteration 2", :project => @project, :start_date => 16.weeks.ago, :end_date => 15.weeks.ago
      Generate.story :bucket => iteration, :points => 10, :status => Status.complete
    end
    When "the user views the project summary (2)" do
      click_logout_link
      a_user_viewing_a_project :project => @project      
    end 
    Then "they see the average velocity is 10 (2)"do
      see_average_velocity 10
    end
    
    Given "the user completes a third iteration worth 10 points (3)" do
      iteration = Generate.iteration "iteration 3", :project => @project, :start_date => 14.weeks.ago, :end_date => 13.weeks.ago
      Generate.story :bucket => iteration, :points => 10, :status => Status.complete
    end
    When "the user views the project summary (3)" do
      click_logout_link
      a_user_viewing_a_project :project => @project      
    end 
    Then "they see the average velocity is 10 (3)"do
      see_average_velocity 10
    end
    
    Given "the user completes a fourth iteration worth 40 points (4)" do
      iteration = Generate.iteration "iteration 4", :project => @project, :start_date => 12.weeks.ago, :end_date => 11.weeks.ago
      Generate.story :bucket => iteration, :points => 40, :status => Status.complete
    end
    When "the user views the project summary (4)" do
      click_logout_link
      a_user_viewing_a_project :project => @project                  
    end
    Then "they see the average velocity is 25 (4)" do
      see_average_velocity 25      
    end
    
    Given "the user completes a fifth iteration worth 35 points (5)" do
      iteration = Generate.iteration "iteration 5", :project => @project, :start_date => 10.weeks.ago, :end_date => 9.weeks.ago
      Generate.story :bucket => iteration, :points => 35, :status => Status.complete      
    end
    When "the user views the project summary (5)" do
      click_logout_link
      a_user_viewing_a_project :project => @project                  
    end
    Then "they see the average velocity is 30 (5)" do
      see_average_velocity 30
    end
    
    Given "the user completes a sixth iteration worth 47 points (6)" do
      iteration = Generate.iteration "iteration 6", :project => @project, :start_date => 8.weeks.ago, :end_date => 7.weeks.ago
      Generate.story :bucket => iteration, :points => 47, :status => Status.complete
    end
    When "the user views the project summary (6)" do
      click_logout_link
      a_user_viewing_a_project :project => @project                  
    end
    Then "they see the average velocity is 38 (6)" do
      see_average_velocity 38      
    end
    
    Given "the user completes a seventh iteration worth 47 points (7)" do
      iteration = Generate.iteration "iteration 7", :project => @project, :start_date => 6.weeks.ago, :end_date => 5.weeks.ago
      Generate.story :bucket => iteration, :points => 47, :status => Status.complete
    end
    When "the user views the project summary (7)" do
      click_logout_link
      a_user_viewing_a_project :project => @project                  
    end
    Then "they see the average velocity is 42 (7)" do 
      see_average_velocity 42
    end
        
  end
end