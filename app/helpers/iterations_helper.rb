module IterationsHelper
  def display_stories_list_for_iteration(iteration)
    if iteration.show?
      render :partial  => 'stories/list', :locals => { :stories => iteration.stories } 
    else
      link_to_remote "show iteration", 
        :url => stories_iteration_path(iteration.project.id, iteration.id), 
        :method => :get, 
        :loading => "Element.update('notice', 'Loading iteration #{iteration.id}...') ; Element.show('notice')", 
        :success => "Element.hide('notice')"
    end
  end
end
