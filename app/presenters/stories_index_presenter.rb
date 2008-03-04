class StoriesIndexPresenter < PresentationObject
  attr_writer :text
  
  VIEWS = %w( iterations tags )
  constructor :project, :view, :search, :strict => false
  
  VIEWS.each do |the_view|
    declare "#{the_view}?" do
      view == the_view ? true : false
    end
  end

  declare :view do
    VIEWS.include?(@view) ? @view : VIEWS.first
  end
  
  declare :iteration do
    @search && @search[:iteration] ? @search[:iteration] : "recent"
  end
  
  declare :text do
    @search  && @search[:text] ? @search[:text] : nil
  end

  declare :stories do
    @project.stories.search(:iteration => iteration, :text => text)
  end
    
  declare :iterations do
    IterationsPresenter.new(
      :stories => stories,
      :project => @project)
  end
  
  declare :tags do
    StoryTagsPresenter.new(
      :tags => @project.story_tags,
      :project => @project
    )
  end
end