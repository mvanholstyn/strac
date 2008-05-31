require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectPresenter do
  
  before do
    @project = mock_model(Project)
    @presenter = ProjectPresenter.new(:project => @project)
  end

  describe "delegations" do
    it_delegates :class, :id, :errors, :new_record?, :to_param,
                 :completed_points, :remaining_points, :total_points,
                 :completed_iterations, :average_velocity, 
                 :estimated_remaining_iterations, :estimated_completion_date,
                 :iterations, :name, :recent_activities, :users, 
                 :on => :presenter, :to => :project
  end
  
  describe '#display_chart?' do
    it "returns false when there are 0 total points" do
      @project.stub!(:total_points).and_return(0)
      @presenter.display_chart?.should be_false
    end

    it "returns true when there are iterations, stories and more than 0 total points" do
      @project.stub!(:total_points).and_return(1)
      @presenter.display_chart?.should be_true   
    end
    
  end

end