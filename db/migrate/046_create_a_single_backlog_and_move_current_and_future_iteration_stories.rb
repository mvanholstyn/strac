class CreateASingleBacklogAndMoveCurrentAndFutureIterationStories < ActiveRecord::Migration
  class Story < ActiveRecord::Base 
    belongs_to :bucket
  end

  class Project < ActiveRecord::Base
    has_many :iterations
    has_many :backlogged_stories, :class_name => "Story", :conditions => "bucket_id IS NULL", :order => "position ASC"
    
    def current_iterations
      iterations.find :all, :conditions => [ "? BETWEEN start_date AND end_date", Date.today ]
    end
    
    def future_iterations
      iterations.find :all, :conditions => [ "start_date > ?", Date.today ], :order => "start_date ASC"
    end
  end  
  
  class Bucket < ActiveRecord::Base
    belongs_to :project
    has_many :stories, :order => "position ASC"
  end
  
  class Iteration < Bucket 
  end

  def self.up
    Project.find(:all).each do |project|
      positioned_ids = [0]
      position_counter = 0
      backlogged_stories = project.backlogged_stories
      
      # move stories in the current iteration into the backlog and give them a new position
      project.current_iterations.map(&:stories).flatten.each do |story|
        positioned_ids << story.id
        story.update_attributes(:bucket_id => nil, :position => position_counter+=1)                
      end

      # move stories in future iterations into the backlog and give them a new position
      project.future_iterations.map(&:stories).flatten.each do |story|
        positioned_ids << story.id
        story.update_attributes(:bucket_id => nil, :position => position_counter+=1)        
      end
      
      # reposition all stories that were in the backlog originally excluding the ones we just moved from other iterations
      Story.update_all "position = position + #{position_counter}", "bucket_id IS NULL AND project_id = #{project.id} AND id NOT IN(#{positioned_ids.join(',')})"

      # remove the end_date for the current iteration
      project.current_iterations.each{ |iteration| iteration.update_attribute(:end_date, nil) }

      # delete the future iterations
      project.future_iterations.each{ |iteration| iteration.destroy }
    end
  end

  def self.down
  end
end
