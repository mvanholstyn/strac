require File.expand_path(File.dirname(__FILE__) + "/../helper")

module ProjectStatsStoryHelper
  def make_stories_completed(stories)
    stories.each do |story|
      story.update_attribute :status, Status.complete
    end
  end

  def move_stories_to_iteration(stories, iteration)
    stories.each do |story|
      story.update_attribute :bucket, iteration
    end
  end

  def generate_stories_for_project(project)
    [
      Generate.story(:summary => "story 1", :points => "1", :project => project),
      Generate.story(:summary => "story 2", :points => "2", :project => project),
      Generate.story(:summary => "story 3", :points => "4", :project => project),
      Generate.story(:summary => "story 4", :points => "0", :project => project) 
    ]
  end

  def destroy_stories_and_iterations
    Story.destroy_all
    Iteration.destroy_all
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
  
  def see_completed_iterations(num)
    see_project_summary do
      response.should have_tag('.completed_iterations', num.to_s.to_regexp)
    end
  end
  
  def see_zero_completed_iterations
    see_completed_iterations 0
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