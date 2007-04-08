class CommentsController < ApplicationController
  before_filter :find_story
  
  layout 'comments'
  
  # GET /comments
  # GET /comments.xml
  def index
    @comments = @story.comments(true)
    respond_to do |format|
      format.html # index.erb
      format.xml  { render :xml => @story.comments(true).to_xml }
      format.js # index.js
    end
  end
  
  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = @story.comments.find(params[:id])

    respond_to do |format|
      format.js # show.rjs
      format.xml { render :xml => @comment.to_xml }
    end
  end  
  
  # GET /comments/new
  def new
    @comment = @story.comments.build
    @comment.commenter = @story

    respond_to do |format|
      format.js # new.rjs
    end
  end
  
  # POST /comments
  # POST /comments.xml
  def create
   @comment = @story.comments.build(params[:comment])
   @comment.user = User.current_user

   respond_to do |format|
     if @comment.save
       format.js do
         render :action => "create.rjs"
       end
       format.xml { head :created, :location => comment_url(@comment) }
     else
       format.js do
         render :action => "new"
       end
       format.xml { render :xml => @comment.errors.to_xml }
     end
   end
  end
  
  
 private
  def find_story
    @story = Story.find( params[:story_id] )
  end
  
end
