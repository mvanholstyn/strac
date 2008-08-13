class AddIterationSnapshotFields < ActiveRecord::Migration
  def self.up
    create_table :snapshots do |t|
      t.integer :total_points
      t.integer :completed_points
      t.integer :remaining_points
      t.float   :average_velocity
      t.float   :estimated_remaining_iterations
      t.date    :estimated_completion_date
      t.integer :bucket_id
      t.timestamps
    end
    
    Project.find(:all).each do |project|
      project.iterations.each do |iteration|
              if project.name =~ /Quest/
puts iteration.name
        puts({    :total_points => iteration.total_points,
          :completed_points => iteration.completed_points,
          :remaining_points => iteration.remaining_points,
          :average_velocity => iteration.average_velocity,
          :estimated_remaining_iterations => iteration.estimated_remaining_iterations,
          :estimated_completion_date => iteration.estimated_completion_date}.inspect)
              end
        Snapshot.create!(
          :bucket => iteration,
          :total_points => iteration.total_points,
          :completed_points => iteration.completed_points,
          :remaining_points => iteration.remaining_points,
          :average_velocity => iteration.average_velocity,
          :estimated_remaining_iterations => iteration.estimated_remaining_iterations,
          :estimated_completion_date => iteration.estimated_completion_date
        )
      end
    end
  end

  def self.down
    drop_table :snapshots
  end
  
  class Project < ActiveRecord::Base
    has_many :iterations
    has_many :stories
  end

  class Status < ActiveRecord::Base
    class << self
      def defined
        @defined ||= Status.find( :first, :conditions=>{:name=>"defined"} ) || 
          Status.create!(:name => "defined", :color => "blue")
      end
    
      def in_progress
        @in_progress ||= Status.find( :first, :conditions=>{:name=>"in progress"} ) || 
          Status.create!(:name => "in progress", :color => "yellow")
      end
    
      def complete
        @complete ||= Status.find( :first, :conditions=>{:name=>"complete"} ) || 
          Status.create!(:name => "complete", :color => "green" )
      end
    
      def rejected
        @rejected ||= Status.find( :first, :conditions=>{:name=>"rejected"} ) || 
          Status.create!(:name => "rejected", :color => "black")
      end
    
      def blocked
        @blocked ||= Status.find( :first, :conditions=>{:name=>"blocked"} ) || 
          Status.create!(:name => "blocked", :color => "blocked")
      end
    
      def statuses
        [ defined, in_progress, complete, rejected, blocked ]
      end
    end
  end
  
  class Story < ActiveRecord::Base
    belongs_to :project
  end
  
  class Bucket < ActiveRecord::Base
    has_one :snapshot
    belongs_to :project
    has_many :stories
  end
  
  class Iteration < Bucket 
    def total_points
      sum = project.stories.sum( :points, 
        :joins => "LEFT JOIN #{Bucket.table_name} b ON b.id=#{Story.table_name}.bucket_id",
        :conditions => [ "(b.type = ? OR b.type IS NULL) AND (status_id NOT IN (?) OR status_id IS NULL)", 
            Iteration.name.split(/::/).last, [Status.rejected.id]] ) 
      sum || 0
    end
  
    def completed_points
      sum = stories.sum( :points, 
        :joins => "LEFT JOIN #{Bucket.table_name} b ON b.id=#{Story.table_name}.bucket_id",
        :conditions => [ "(b.type = ? OR b.type IS NULL) AND status_id IN (?)", 
          Iteration.name.split(/::/).last, [Status.complete.id] ] ) 
      sum || 0
    end
  
    def remaining_points
      points = previous_iterations.inject(0){ |sum,iteration| sum += iteration.completed_points }
      points += completed_points
      total_points - points
    end
  
    def average_velocity
      points = previous_iterations.inject([]) do |points, iteration|
        points << iteration.completed_points
      end
      VelocityCalculator.compute_weighted_average(points)
    end
  
    def estimated_remaining_iterations
      average_velocity.zero? ? 0 : remaining_points.to_f / average_velocity.to_f
    end
  
    def estimated_completion_date
      Date.today + estimated_remaining_iterations * 7
    end

    def previous_iterations
      project.iterations.find(
        :all, 
        :conditions=>["end_date < ? ", self.start_date], 
        :order => "start_date ASC"
      )
    end
  end

  class Snapshot < ActiveRecord::Base
    belongs_to :bucket
  end
  
end
