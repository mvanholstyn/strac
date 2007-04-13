require File.dirname(__FILE__) + '/../test_helper'

class StoryCommentsTest < Test::Unit::TestCase
  
  def setup
    @story = stories(:one)
  end
  
  def teardown
    Comment.delete_all
    Story.delete_all
  end
  
  def test_adding_a_valid_comment_to_a_story_should_work
    comment = Comment.new :content=>"story comment", :user_id=>1
  
    assert comment.valid?, "comment was not valid when it should have been!"
    
    is_comment_saved = @story.comments << comment
    assert is_comment_saved, "comment should have been added to the story, but it wasn't!"
    
    assert_equal 1, @story.comments.size, "number of comments on the story was wrong!"
    assert_equal "story comment", @story.comments.first.content, "the story comment was wrong!"
  end
  
  def test_adding_an_invalid_comment_to_a_story_without_user_should_fail
    comment = Comment.new
    assert !comment.valid?, "comment should have been invalid but it wasn't!"
    assert_equal 0, @story.comments.size, "number of comments on the story should have been zero!"
  end
  
end