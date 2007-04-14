require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase

  def test_associations
    assert_association Comment, :belongs_to, :commenter, User, :class_name=>"User", :foreign_key=>"commenter_id"
    assert_association Comment, :belongs_to, :commentable, :polymorphic=>true
  end
  
  def test_should_have_user_id
    comment = Comment.new :content=>"story"
    assert !comment.valid?
    assert_equal "can't be blank", comment.errors.on(:commenter_id)
  end
  
  def test_should_have_content
    comment = Comment.new :commenter_id => 1
    assert !comment.valid?
    assert_equal "can't be blank", comment.errors.on(:content)
  end
  
end
