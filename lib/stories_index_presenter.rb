class StoriesIndexPresenter < PresentationObject
  VIEWS = %w( iterations tags )
  constructor :project, :view, :strict => false
  
  VIEWS.each do |the_view|
    declare "#{the_view}?" do
      view == the_view ? true : false
    end
  end

  declare :view do
    VIEWS.include?(@view) ? @view : VIEWS.first
  end
    
  declare :iterations_presenter do
    IterationsPresenter.new(
      :iterations => @project.iterations_ordered_by_start_date,
      :backlog => @project.backlog_iteration,
      :project => @project)
  end
end