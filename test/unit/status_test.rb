require File.dirname(__FILE__) + '/../test_helper'

class StatusTest < Test::Unit::TestCase
  # fixtures are loaded in test_helper since statuses are global to the app
  fixtures :statuses
  
  def teardown
    Status.delete_all
  end

  def test_defined_exists_as_expected
    assert Status.defined
    assert_equal 1, Status.defined.id
  end

  def test_in_progress_exists_as_expected
    assert Status.in_progress
    assert_equal 2, Status.in_progress.id
  end

  def test_complete_exists_as_expected
    assert Status.complete
    assert_equal 3, Status.complete.id
  end

  def test_rejected_exists_as_expected
    assert Status.rejected
    assert_equal 4, Status.rejected.id
  end

  def test_blocked_exists_as_expected
    assert Status.blocked
    assert_equal 5, Status.blocked.id
  end
  
end
