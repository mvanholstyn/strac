class StoryTagsPresenter < PresentationObject
  include Enumerable
  
  constructor :tags, :project

  delegate :tagless_stories, :to => :@project
  
  declare :tagless do
    Tag.new :name => "Stories without tags"
  end
  
  def each &block
    @tags.sort_by(&:name).each &block
  end
end