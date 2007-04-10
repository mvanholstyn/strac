class CommentsController < ApplicationController
  before_filter :initialize_params
  before_filter :find_story

  # GET /comments
  # GET /comments.xml
  def index
    @comments = @story.comments(true)
    
    respond_to do |format|
      format.html { render :action => "index.erb" }
      format.xml { render :xml => @story.comments(true).to_xml }
      format.js { render :action => "index.rjs" }
    end
  end
  
  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = @story.comments.find(params[:id])

    respond_to do |format|
      format.js { render :action => "show.rjs" }
      format.xml { render :xml => @comment.to_xml }
    end
  end  
  
  # GET /comments/new
  def new
    @comment = @story.comments.build
    @comment.commenter = @story

    respond_to do |format|
      format.js { render :action => "new.rjs" }
    end
  end
  
  # POST /comments
  # POST /comments.xml
  def create
   @comment = @story.comments.build(params[:comment])
   @comment.user = User.current_user

   respond_to do |format|
     if @comment.save
       format.js { render :action => "create.rjs" }
       format.xml { head :created, :location => comment_url(@comment) }
     else
       format.js { render :action => "new.rjs" }
       format.xml { render :xml => @comment.errors.to_xml }
     end
   end
  end
  
  private
 
  def find_story
    @story = Story.find( params[:story_id] )
  end
  
  def initialize_params
    puts params.inspect
    @is_rendering_inline = params[:inline] ? true : false
    true
  end
end
