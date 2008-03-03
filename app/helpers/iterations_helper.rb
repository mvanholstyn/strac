module IterationsHelper
  def display_stories_list_for_iteration(iteration)
    render :partial  => 'stories/list', :locals => { :stories => iteration.stories } 
  end  
end
