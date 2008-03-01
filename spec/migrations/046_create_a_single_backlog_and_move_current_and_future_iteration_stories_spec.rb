require File.dirname(__FILE__) + '/../spec_helper'

class CreateASingleBacklogAndMoveCurrentAndFutureIterationStoriesSpec # scopes the redefined model inside this to prevent it from breaking other tests
  class Project < ActiveRecord::Base
    has_many :iterations

    def find_current_iteration
      iterations.find :first, :conditions => [ "? BETWEEN start_date AND end_date", Date.today ]
    end
    
    def find_future_iterations
      iterations.find :all, :conditions => [ "start_date > ?", Date.today ], :order => "start_date ASC"
    end
  end
  
  class Story < ActiveRecord::Base 
    belongs_to :bucket
    belongs_to :project
  end
  
  class Bucket < ActiveRecord::Base
    belongs_to :project
    has_many :stories
  end
  
  class Iteration < Bucket 
  end

  describe "046CreateASingleBacklogAndMoveCurrentAndFutureIterationStories" do
    before(:all) do
      drop_all_tables
      migrate :version => 45
      Project.delete_all
      
      create_projects
      create_current_iterations_with_stories
      create_past_iterations_with_stories
      create_future_iterations_with_stories
      create_backlogged_stories

      migrate :version => 46
    end
  
    after(:all) do
      drop_all_tables
      migrate     
    end
    
    it "moves stories in the current iteration for each project into the backlog" do
      @current_stories.each do |story|
        story.reload.bucket.should be_nil
      end
      @current_iterations.each do |iteration|
        iteration.stories.reload.should be_empty
      end
    end

    it "moves stories from future iterations for each project into the backlog" do
      (@future_stories + @future_future_stories).each do |story|
        story.reload.bucket.should be_nil        
      end
      (@future_iterations + @future_future_iterations).each do |iteration|
        iteration.stories.reload.should be_empty
      end
    end
    
    it "does not move stories from past iterations" do
      @past_stories.each do |story|
        story.reload.bucket.should be_kind_of(Iteration)
      end
    end
    
    it "repositions the backlog so the current iteration stories are first, then future iteration stories, and then the original backlog on a per-project basis" do
      all_stories = @current_stories + @future_stories + @future_future_stories + @backlogged_stories

      project1_stories = all_stories.select{ |story| story.project == @projects.first }
      project1_stories.each_with_index do |story, i|
        position = i + 1
        story.reload.position.should == position
      end
      
      project2_stories = all_stories.select{ |story| story.project == @projects.last }
      project2_stories.each_with_index do |story, i|
        position = i + 1
        story.reload.position.should == position
      end
    end
    
    it "removes the current iteration" do
      @projects.each do |project|
        project.find_current_iteration.should be_nil
      end
    end
    
    it "removes the future iterations" do
      @projects.each do |project|
        project.find_future_iterations.should be_empty
      end      
    end
  
    def create_projects
      @projects = [ Project.create!(:name => "Project1"), Project.create!(:name => "Project2")]
    end
    
    def create_current_iterations_with_stories
      @current_iterations = [
        Iteration.create!(:name => "Current Iteration for Project1", :project => @projects.first, :start_date => Date.yesterday, :end_date => Date.tomorrow),
        Iteration.create!(:name => "Current Iteration for Project2", :project => @projects.last, :start_date => Date.yesterday, :end_date => Date.tomorrow),
      ]
      @current_stories = []
      2.times do |i|
        position = i + 1
        @current_stories << Story.create!(:summary => "current story #{i+1} for project 1", :project => @projects.first, :position => position)
        @current_iterations.first.stories << @current_stories.last
        @current_stories << Story.create!(:summary => "current story #{i+1} for project 2", :project => @projects.last, :position => position)
        @current_iterations.last.stories << @current_stories.last
      end
    end
    
    def create_past_iterations_with_stories
      @past_iterations = [
        Iteration.create!(:name => "Past iteration for Project 1", :project => @projects.first, :start_date => Date.yesterday - 1.week, :end_date => Date.yesterday - 1.day),
        Iteration.create!(:name => "Past iteration for Project 2", :project => @projects.last, :start_date => Date.yesterday - 1.week, :end_date => Date.yesterday - 1.day)
      ]
      @past_stories = []
      2.times do |i|
        @past_stories << Story.create!(:summary => "past story #{i+1} for project 1", :project => @projects.first, :position => i+1)
        @past_iterations.first.stories << @past_stories.last
        @past_stories << Story.create!(:summary => "past story #{i+1} for project 2", :project => @projects.last, :position => i+1)
        @past_iterations.last.stories << @past_stories.last
      end
    end
    
    def create_future_iterations_with_stories
      @future_iterations = [
        Iteration.create!(:name => "1st Future iteration for Project 1", :project => @projects.first, :start_date => Date.today + 1.week, :end_date => Date.today + 2.weeks),
        Iteration.create!(:name => "1st Future iteration for Project 2", :project => @projects.last, :start_date => Date.today + 1.week, :end_date => Date.today + 2.weeks)
      ]
      @future_stories = []
      2.times do |i|
        position = i + 1
        @future_stories << Story.create!(:summary => "future story #{i+1} for project 1", :project => @projects.first, :position => position)
        @future_iterations.first.stories << @future_stories.last
        @future_stories << Story.create!(:summary => "future story #{i+1} for project 2", :project => @projects.last, :position => position)
        @future_iterations.last.stories << @future_stories.last
      end

      @future_future_iterations = [
        Iteration.create!(:name => "2nd Future iteration for Project 1", :project => @projects.first, :start_date => Date.today + 3.weeks, :end_date => Date.today + 4.weeks),
        Iteration.create!(:name => "2nd Future iteration for Project 2", :project => @projects.last, :start_date => Date.today + 3.weeks, :end_date => Date.today + 4.weeks)
      ]
      @future_future_stories = []
      2.times do |i|
        position = i + 1
        @future_future_stories << Story.create!(:summary => "future future story #{i+1} for project 1", :project => @projects.first, :position => position)
        @future_future_iterations.first.stories << @future_future_stories.last
        @future_future_stories << Story.create!(:summary => "future future story #{i+1} for project 2", :project => @projects.last, :position => position)
        @future_future_iterations.last.stories << @future_future_stories.last
      end
    end

    def create_backlogged_stories
      @backlogged_stories = []
      3.times do |i|
        position = i + 1
        @backlogged_stories << Story.create!(:summary => "backlogged story #{i + 1} for project1", :project => @projects.first, :position => position)
        @backlogged_stories << Story.create!(:summary => "backlogged story #{i + 1} for project2", :project => @projects.last, :position => position)
      end
    end
  end
end