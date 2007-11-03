require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  before(:each) do
    @comment = Comment.new
    @comment.should_not be_valid
  end

  it "should belong to a commenter" do
    Comment.should have_association(:belongs_to, :commenter, User)
  end
  
  it "should belong to a comment" do
    Comment.should have_association(:belongs_to, :commentable, :polymorphic=>true)
  end

  it "should always have a commenter" do
    @comment.errors.on(:commenter_id).should_not be_blank
  end
  
  it "should always have a commentable" do
    @comment.errors.on(:commentable_id).should_not be_blank
    @comment.errors.on(:commentable_type).should_not be_blank
  end

  it "should always have content" do
    @comment.errors.on(:content).should_not be_blank
  end

end
