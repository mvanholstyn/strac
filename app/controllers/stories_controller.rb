class StoriesController < ApplicationController
  # GET /stories
  # GET /stories.xml
  def index
    @stories = Story.find(:all, :order => :position)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @stories.to_xml }
    end
  end

  # GET /stories/1
  # GET /stories/1.xml
  def show
    @story = Story.find(params[:id])

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
    @story = Story.find(params[:id])
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
    @story = Story.find(params[:id])

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
    @story = Story.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to stories_url }
      format.xml  { head :ok }
    end
  end

  # PUT /stories/reorder
  def reorder
    respond_to do |format|
      if Story.reorder params[:stories]
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
    @story = Story.find(params[:id])
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

end
