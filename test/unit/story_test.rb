require File.dirname(__FILE__) + '/../test_helper'

class StoryTest < Test::Unit::TestCase
  fixtures :stories

  def create_story( options={} )
    StoryObserver.instance.expects( :create_activity )
    default_options = { :summary=>"Summary",
                          :description=>"Description",
                          :points=>"1",
                          :tag_list=>'tag',
                          :project_id=>1 }
    options.reverse_merge!( default_options )
    story = Story.new(options)
    assert story.save
    story
  end
  
  def test_associations
    assert_association Story, :has_many, :comments, Comment, :as => :commentable
  end

  def test_creating_a_stort
    count = Story.count
    story = create_story
    assert_equal count+1, Story.count

    story.reload
    assert_equal 'Summary', story.summary
    assert_equal 'Description', story.description_source
    assert_equal 1, story.points
    assert_equal 'tag', story.tag_list
  end

  def test_summary_attribute_should_be_required
    story = Story.new
    story.valid?

    assert_instance_of String, story.errors.on( :summary )

    story.summary = "My Summary"
    story.valid?

    assert_nil story.errors.on( :summary )
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

  def test_story_should_support_tags
    tag_list = 'tag1, tag2, tag3'
    story = create_story( :tag_list => tag_list )

    assert tag_list == story.tag_list
    story.reload
    assert tag_list == story.tag_list
  end

  def test_story_should_have_status_id
    story = Story.new
    assert story.respond_to?( :status_id )
  end

  def test_story_should_have_priority_id
    story = Story.new
    assert story.respond_to?( :priority_id )
  end

end

