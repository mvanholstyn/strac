require File.dirname(__FILE__) + '/../test_helper'

class IterationTest < Test::Unit::TestCase
  
  def setup
    Iteration.delete_all
  end
  
  def test_validates_presence_of_start_date
    iteration = Iteration.new( :project_id => 1, :start_date => nil, :end_date => Date.today )
    assert ! iteration.valid?
    assert_equal 1, iteration.errors.size
    assert_not_nil iteration.errors.on( :start_date )
  end
  
  def testtvalidates_presence_of_end_date
    iteration = Iteration.new( :project_id => 1, :start_date => Date.today, :end_date => nil )
    assert ! iteration.valid?
    assert_equal 1, iteration.errors.size
    assert_not_nil iteration.errors.on( :end_date )
  end
  
  def test_validates_presence_of_project_id
    iteration = Iteration.new( :project_id => nil, :start_date => Date.today, :end_date => Date.today + 7 )
    assert ! iteration.valid?
    assert_equal 1, iteration.errors.size
    assert_not_nil iteration.errors.on( :project_id )
  end
  
  def test_validates_iterations_do_not_overlap
    first_iteration = Iteration.create!( :project_id => 1, :start_date => Date.today, :end_date => Date.today + 7 )

    second_iteration = Iteration.new( :project_id => 1, :start_date => Date.today + 7, :end_date => Date.today + 14 )
    assert ! second_iteration.valid?
    assert_equal 1, second_iteration.errors.size
    
    second_iteration = Iteration.new( :project_id => 1, :start_date => Date.today - 7, :end_date => Date.today )
    assert ! second_iteration.valid?
    assert_equal 1, second_iteration.errors.size
    
    second_iteration = Iteration.new( :project_id => 1, :start_date => Date.today + 1, :end_date => Date.today + 2 )
    assert ! second_iteration.valid?
    assert_equal 1, second_iteration.errors.size
  end
  
  def test_validates_start_date_is_before_end_date
    iteration = Iteration.new( :project_id => 1, :start_date => Date.today, :end_date => Date.today )
    assert ! iteration.valid?
    assert_equal 1, iteration.errors.size
    
    iteration = Iteration.new( :project_id => 1, :start_date => Date.today + 7, :end_date => Date.today )
    assert ! iteration.valid?
    assert_equal 1, iteration.errors.size
  end
  
  def test_validates_budget
    iteration = Iteration.new( :project_id => 1, :start_date => Date.today, :end_date => Date.today+1, :budget => 25 )
    assert iteration.valid?
    
    assert_equal 25, iteration.budget, "iteration budget was wrong!"
  end
  
  def test_points_completed
    iteration = Iteration.create( :project_id => 1, :start_date => Date.today, :end_date => Date.today+1, :budget => 25 )

    expect_points_completed_for( iteration, 10 )
    
    assert_equal 10, iteration.points_completed, "points completed for iteration was wrong!"
  end
  
  def test_points_completed_with_no_stories_defined_with_points
    iteration = Iteration.create( :project_id => 1, :start_date => Date.today, :end_date => Date.today+1, :budget => 25 )

    expect_points_completed_for( iteration, nil )
    
    assert_equal 0, iteration.points_completed, "points completed for iteration was wrong!"
  end
  
  def test_points_remaining
    iteration = Iteration.create( :project_id => 1, :start_date => Date.today, :end_date => Date.today+1, :budget => 25 )
    
    expect_points_completed_for( iteration, 10 )
    
    assert_equal 15, iteration.points_remaining, "points remaining for iteration was wrong!"
  end
    
  
  ## EXPECT HELPER METHODS
  
  def expect_points_completed_for( iteration, points )
    Story.expects( :sum ).with( :points, :conditions => { :iteration_id => iteration.id, :status_id => Status.complete.id }).returns(points)
  end
  
  
end
