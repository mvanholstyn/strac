class CommentsController < ApplicationController
  restrict_to :user

  before_filter :find_story
      
  def index
    @comments = @story.comments
    respond_to :html, :js
  end
    
  def new
    @comment = @story.comments.build
    respond_to :js
  end
  
  def create
    @comment = @story.comments.build(params[:comment])
    @comment.commenter = current_user

    respond_to do |format|
      if @comment.save
        format.js
      else
        format.js { render :action => "new" }
      end
    end
  end
  
private
 
  def find_story
    @story = Story.find(params[:story_id])
  end
end
