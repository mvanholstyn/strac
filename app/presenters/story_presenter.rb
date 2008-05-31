class StoryPresenter < PresentationObject
  
  def initialize(options)
    @story = options[:story]
  end
  
  delegate :class, :errors, :id, :new_record?, :to_param,
      :bucket, :bucket_id, :comments, :description, :errors, :points,
      :priority_id, :project, :project_id, :responsible_party, :responsible_party_type_id,
      :status, :status_id, :summary, :tag_list,
      :to => :@story
  
  declare :possible_statuses do
    Status.all
  end

  declare :possible_priorities do
    Priority.all
  end

end