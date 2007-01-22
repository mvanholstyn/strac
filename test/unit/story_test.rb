require File.dirname(__FILE__) + '/../test_helper'

class StoryTest < Test::Unit::TestCase
  fixtures :stories

  def test_summary_attribute_should_be_required
    story = Story.new
    story.valid?

    assert_instance_of String, story.errors.on( :summary )

    story.summary = "My Summary"
    story.valid?

    assert_nil story.errors.on( :summary )
  end

  def test_description_attribute_should_be_required
    story = Story.new
    story.valid?

    assert_instance_of String, story.errors.on( :description )

    story.description = "My Description"
    story.valid?

    assert_nil story.errors.on( :description )
  end

  def test_points_attribute_should_not_be_required
    story = Story.new
    story.valid?

    assert_nil story.errors.on( :points )
  end

  def test_position_attribute_should_not_be_required
    story = Story.new
    story.valid?

    assert_nil story.errors.on( :position )
  end

  def test_points_attribute_should_be_numerical
    story = Story.new :points => 'three'
    story.valid?

    assert_instance_of String, story.errors.on( :points )

    story.points = 3
    story.valid?

    assert_nil story.errors.on( :points )
  end

  def test_position_attribute_should_be_numerical
    story = Story.new :position => 'zero'
    story.valid?

    assert_instance_of String, story.errors.on( :position )

    story.position = 0
    story.valid?

    assert_nil story.errors.on( :position )
  end

  def test_reoreder_should_update_position
    assert_equal 0, Story.find( 1 ).position
    assert_equal 1, Story.find( 2 ).position

    assert Story.reorder( [ 2, 1 ] )

    assert_equal 1, Story.find( 1 ).position
    assert_equal 0, Story.find( 2 ).position
  end
end
