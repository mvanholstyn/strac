class StoriesController < ApplicationController
  before_filter :load_iterations

  # GET /stories
  # GET /stories.xml
  def index
    @stories = Story.find( :all, :include => [ :tags, :iteration ], :order => :position ).group_by( &:iteration )

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @stories.to_xml }
    end
  end

  # GET /stories/1
  # GET /stories/1.xml
  def show
    @story = Story.find(params[:id], :include => :tags)

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @story.to_xml }
    end
  end

  # GET /stories/new
  def new
    @story = Story.new
  end

  # GET /stories/1;edit
  def edit
    @story = Story.find(params[:id], :include => :tags)
  end

  # POST /stories
  # POST /stories.xml
  def create
    @story = Story.new(params[:story])

    respond_to do |format|
      if @story.save
        flash[:notice] = %("#{@story.summary}" was successfully created.)
        format.html { redirect_to params[:redirect_to] || stories_url }
        format.xml  { head :created, :location => story_url(@story) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @story.errors.to_xml }
      end
    end
  end

  # PUT /stories/1
  # PUT /stories/1.xml
  def update
    @story = Story.find(params[:id], :include => :tags)

    respond_to do |format|
      if @story.update_attributes(params[:story])
        flash[:notice] = %("#{@story.summary}" was successfully updated.)
        format.html { redirect_to stories_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @story.errors.to_xml }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.xml
  def destroy
    @story = Story.find(params[:id], :include => :tags)
    @story.destroy

    respond_to do |format|
      format.html { redirect_to stories_url }
      format.xml  { head :ok }
    end
  end

  # PUT /stories/reorder
  def reorder
    respond_to do |format|
      #TODO: This will fail if complete stories are hidden..."
      param_to_use = params.select { |k,v| k =~ /^iteration_(\d+|nil)$/ }.first
      if Story.reorder( param_to_use.last,
                        :iteration_id => eval( param_to_use.first.scan( /^iteration_(\d+|nil)$/ ).flatten.first ) )
        format.html { render_notice "Priorities have been successfully updated." }
        format.xml { head :ok }
      else
        format.html do
          render_error "There was an error while updating priorties. If the problem persists, please contact technical support." do |page|
            #TODO: If unsuccessful, replace the stories list
            #page.replace_html "stories", ""
          end
        end
        format.xml { render :xml => "" }
      end
    end
  end

  # PUT /stories/1;update_points
  def update_points
    @story = Story.find(params[:id], :include => :tags)
    @story.points = params[:story][:points]

    respond_to do |format|
      if @story.save
        format.js do
          render_notice %("#{@story.summary}" was successfully updated.) do |page|
            page["story_#{@story.id}_points"].replace_html( @story.points || "&infin;" )
          end
        end
      else
        format.js do
          render_error %("#{@story.summary}" was not successfully updated.) do |page|
            page["story_#{@story.id}_points"].replace_html( @story.reload.points || "&infin;" )
          end
        end
      end
    end
  end

  # PUT /stories/1;update_complete
  def update_complete
    @story = Story.find(params[:id], :include => :tags)
    @story.complete = params[:story][:complete]

    respond_to do |format|
      if @story.save
        stories = Story.find( :all, :include => [ :tags, :iteration ], :conditions => { :iteration_id => @story.iteration }, :order => :position )
        format.js do
          render_notice %("#{@story.summary}" has been marked #{@story.complete? ? "" : "in" }complete.) do |page|
            page["story_#{@story.id}"].className = @story.complete? ? "complete" : "incomplete"
          end
        end
      else
        format.js do
          render_error %("#{@story.summary}" was not successfully updated.) do |page|
            #TODO: Why does this cause a double check to be necessary?
            page["story_#{@story.id}_complete"].checked = @story.reload.complete? ? "checked" : ""
          end
        end
      end
    end
  end

  private
  def load_iterations
    @iterations = Iteration.find :all, :order => 'start_date'
  end
end
