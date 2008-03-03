# == Schema Information
# Schema version: 41
#
# Table name: projects
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   
#  created_at :datetime      
#  updated_at :datetime      
#

class Project < ActiveRecord::Base
  validates_presence_of :name
  
  has_many :invitations
  has_many :time_entries
  has_many :stories
  has_many :activities
  has_many :project_permissions, :dependent => :destroy
  has_many_polymorphs :accessors, :through => :project_permissions, :from => [:users]
  has_many :buckets
  has_many :phases 
  has_many :iterations do 
    def previous
      find(:all, :order => "start_date DESC", :limit => 2)[1]
    end
    
    def current
      find(:first, :order => "start_date DESC")
    end
    
    def backlog
      build(:name => "Backlog")
    end
  
    def find_or_build_current
      current || build( :name => "Iteration #{size + 1}", :start_date => Date.today, :end_date =>  Date.today + 7 )
    end
  end
  has_many :completed_iterations, :source => :iterations, :class_name => Iteration.name, :conditions => [ "end_date < ?", Date.today ]
  has_many :story_tags, :class_name => Tag.name, :finder_sql => '
    SELECT tags.*
    FROM projects
    INNER JOIN stories ON stories.project_id=projects.id
    INNER JOIN taggings ON (taggings.taggable_id=stories.id AND taggings.taggable_type=\'Story\')
    INNER JOIN tags ON tags.id=taggings.tag_id
    WHERE
      projects.id = #{id}
    GROUP BY tags.id'
  has_many :tagless_stories, :class_name => Story.name, :finder_sql => '
    SELECT stories.*
    FROM projects
    INNER JOIN stories ON stories.project_id=projects.id
    LEFT JOIN taggings ON (taggings.taggable_id=stories.id AND taggings.taggable_type=\'Story\')
    WHERE
      projects.id = #{id} AND
      taggings.taggable_id IS NULL'

  
  def iterations_ordered_by_start_date
    iterations.find(:all, :order => :start_date)
  end
  
  def total_points
    sum = stories.sum( :points, 
      :joins => "LEFT JOIN #{Bucket.table_name} b ON b.id=#{Story.table_name}.bucket_id",
      :conditions => [ "(b.type = ? OR b.type IS NULL) AND (status_id NOT IN (?) OR status_id IS NULL)", 
          Iteration.name, [Status.rejected.id]] ) 
    sum || 0
  end
  
  def completed_points
    sum = stories.sum( :points, 
      :joins => "LEFT JOIN #{Bucket.table_name} b ON b.id=#{Story.table_name}.bucket_id",
      :conditions => [ "(b.type = ? OR b.type IS NULL) AND status_id IN (?)", 
        Iteration.name, [Status.complete.id] ] ) 
    sum || 0
  end
  
  def remaining_points
    sum = stories.sum( :points, 
      :joins => "LEFT JOIN #{Bucket.table_name} b ON b.id=#{Story.table_name}.bucket_id",
      :conditions => [ "(b.type = ? OR b.type IS NULL) AND (status_id NOT IN (?) OR status_id IS NULL)",
         Iteration.name, [Status.complete.id, Status.rejected.id] ] )
    sum || 0
  end
  
  def average_velocity
    points = previous_iterations.inject([]) do |points, iteration|
      points << iteration.points_completed
    end
    VelocityCalculator.compute_weighted_average(points) 
  end
  
  def estimated_remaining_iterations
    average_velocity.zero? ? 0 : remaining_points.to_f / average_velocity.to_f
  end
  
  def estimated_completion_date
    Date.today + estimated_remaining_iterations * 7
  end
  
  def recent_activities(days=1)
    self.activities.find( 
      :all, 
      :conditions => ["created_at >= ?",  Date.today - days ],
      :order => "created_at DESC"
    )
  end

  def backlog_iteration
    iterations.build(:name => "Backlog")
  end
  
  def backlog_stories
    stories.find_backlog(:order => :position)
  end

  def update_members(member_ids)
    self.users.clear
    member_ids.each do |member|
      self.users << User.find(member)
    end
  end
  
private

  def previous_iterations
    current = iterations.find_or_build_current
    iterations.find(
      :all, 
      :conditions=>["end_date < ? ", current.start_date], 
      :order => "start_date ASC"
    )
  end
end
