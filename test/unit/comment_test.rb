require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  fixtures :comments

  # Replace this with your real tests.
  def test_associations
    assert_association Comment, :belongs_to, :user, User
    assert_association Comment, :belongs_to, :commenter, :polymorphic=>true
  end
  
  def test_should_have_user_id
    comment = Comment.new :content=>"story"
    assert !comment.valid?
    assert_equal "can't be blank", comment.errors.on(:user_id)
  end
  
  def test_should_have_content
    comment = Comment.new :user_id => 1
    assert !comment.valid?
    assert_equal "can't be blank", comment.errors.on(:content)
  end
end
