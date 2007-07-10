require File.dirname(__FILE__) + '/../../spec_helper'

describe "/comments/index.html.erb with comments" do
  include CommentsHelper
  
  before do
    @story = mock_model(Story)
    @story.stub!(:summary).and_return("Story Summary")
    @story.stub!(:project_id).and_return(1)

    @comment1_commenter = mock_model(User)
    @comment1_commenter.stub!(:username).and_return("zdennis")
    @comment1= mock_model(Comment)
    @comment1.stub!(:commenter).and_return(@comment1_commenter)
    @comment1.stub!(:created_at).and_return(Time.now)
    @comment1.stub!(:content).and_return("boo!")

    @comment2_commenter = mock_model(User)
    @comment2_commenter.stub!(:username).and_return("mcdougal")
    @comment2= mock_model(Comment)
    @comment2.stub!(:commenter).and_return(@comment2_commenter)
    @comment2.stub!(:created_at).and_return(Time.now)
    @comment2.stub!(:content).and_return("hahahah")
    
    assigns[:story] = @story
    assigns[:comments] = [@comment1, @comment2]
  end

  it "should render an empty no comments container" do
    render "/comments/index.html.erb"
    response.should have_tag("#story_#{@story.id}_nocomments", "" )
  end
  
  it "should render a comments list container with two comments" do
    render "/comments/index.html.erb"
    see_comment_list do
      see_comment @comment1
      see_comment @comment2      
    end
  end

  private 
  #
  # HELPERS
  #
    
  def see_comment_list
    response.should have_tag("#story_#{@story.id}_comments_list") do
      yield if block_given?
    end    
  end

  def see_comment comment
    with_tag ".comment" do
      with_tag ".comment-header", "Posted by #{comment.commenter.username} on #{comment_datetime_for(comment.created_at)}"
      with_tag ".comment-body", "#{comment.content}"
    end
  end
  
end


