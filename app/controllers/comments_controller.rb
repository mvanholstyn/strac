class CommentsController < ApplicationController
  before_filter :initialize_params
  before_filter :find_story
      
  # GET /comments
  # GET /comments.xml
  def index
    @comments = @story.comments
    respond_to do |format|
      format.html
      format.xml { render :xml => @story.comments(true).to_xml }
      format.js
    end
  end
    
  # GET /comments/new
  def new
    @comment = @story.comments.build

    respond_to do |format|
      format.js
    end
  end
  
  # POST /comments
  # POST /comments.xml
  def create
   @comment = @story.comments.build(params[:comment])
   @comment.commenter = User.current_user

   respond_to do |format|
     if @comment.save
       format.js
       format.xml { head :created, :location => comment_url(@comment) }
     else
       format.js { render :action => "new" }
       format.xml { render :xml => @comment.errors.to_xml }
     end
   end
  end
  
  private
 
  def find_story
    @story = Story.find( params[:story_id] )
  end
  
  def initialize_params
    @is_rendering_inline_comments = true
    true
  end
end
