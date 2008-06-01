module Project::IterationsAssociationMethods
  def previous
    find(:all, :order => "started_at DESC", :limit => 2)[1]
  end
  
  def current
    find(:first, :conditions => ["started_at <= ? AND ended_at IS NULL", Time.now])
  end
  
  def backlog
    build(:name => "Backlog")
  end

  def find_or_build_current
    current || build( :name => "Iteration #{size + 1}", :started_at => Time.now )
  end
end