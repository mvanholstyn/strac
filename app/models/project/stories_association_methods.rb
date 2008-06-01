module Project::StoriesAssociationMethods

  def search(params)
    joins, conditions, values = [], [], []
  
    unless params[:text].blank?
      joins << "LEFT JOIN taggings ON taggings.taggable_id = stories.id AND taggings.taggable_type = 'Story'"
      joins << "LEFT JOIN tags ON tags.id = taggings.tag_id"
      
      ored_conditions = []
      ["stories.summary", "stories.description", "tags.name"].each do |attribute|
        ored_conditions << "#{attribute} LIKE ?"
        values << "%#{params[:text]}%"
      end
      conditions << "(#{ored_conditions.join(' OR ')})"
    end
  
    case params && params[:iteration]
      when "recent"
        conditions << "(stories.bucket_id IN(?) OR stories.bucket_id IS NULL)"
        values << [proxy_owner.iterations.previous, proxy_owner.iterations.current, proxy_owner.iterations.backlog]
      else
        joins << "LEFT JOIN buckets ON buckets.id = stories.bucket_id"
        conditions << "(buckets.type = 'Iteration' OR buckets.id IS NULL)"
    end
  
    find(:all, :joins => joins.join(" "), :conditions => [conditions.join(" AND "), *values], :group => "stories.id")
  end
  
end