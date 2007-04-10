class StoriesController < ApplicationController
  before_filter :find_project
  before_filter :find_priorities_and_statuses, :only => [ :new, :edit ]

  helper :comments

  # GET /stories
  # GET /stories.xml
  def index
    respond_to do |format|
      format.html { render :action => "index.erb" }
      format.xml { render :xml => @project.stories.to_xml }
    end
  end

  # GET /stories/1
  # GET /stories/1.xml
  def show
    @story = @project.stories.find(params[:id], :include => :tags)

    respond_to do |format|
      format.js { render :action => "show.rjs" }
      format.xml { render :xml => @story.to_xml }
    end
  end

  # GET /stories/new
  def new
    @story = @project.stories.build
    @story.iteration_id = params[:iteration_id]

    respond_to do |format|
      format.js { render :action => "new.rjs" }
    end
  end

  # GET /stories/1;edit
  def edit
    @story = @project.stories.find(params[:id], :include => :tags)

    respond_to do |format|
      format.js { render :action => "edit.rjs" }
    end
  end

  # POST /stories
  # POST /stories.xml
  def create
    @story = @project.stories.build(params[:story])

    respond_to do |format|
      if @story.save
        format.js do
          find_priorities_and_statuses
          render :action => "create.rjs"
        end
        format.xml { head :created, :location => story_url(@project, @story) }
      else
        format.js do
          find_priorities_and_statuses
          render :action => "new.rjs"
        end
        format.xml { render :xml => @story.errors.to_xml }
      end
    end
  end

  # PUT /stories/1
  # PUT /stories/1.xml
  def update
    @story = @project.stories.find(params[:id], :include => :tags)

    respond_to do |format|
      if @story.update_attributes(params[:story])
        #TODO: If this stories iteration is changed, then something should happen
        format.js { render :action => "update.rjs" }
        format.xml { head :ok }
      else
        format.js do
          find_priorities_and_statuses
          render :action => "edit.rjs"
        end
        format.xml { render :xml => @story.errors.to_xml }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.xml
  def destroy
    @story = @project.stories.find(params[:id], :include => :tags)
    @story.destroy
  
    respond_to do |format|
      format.js { render :action => "destroy.rjs" }
      format.html do
        flash[:notice] = %("#{@story.summary}" was successfully destroyed.)
        redirect_to stories_url( @project )
      end
      format.xml  { head :ok }
    end
  end

  # PUT /stories/reorder.js
  def reorder
    respond_to do |format|
      #TODO: This will fail if complete stories are hidden..."
      param_to_use = params.select { |k,v| k =~ /^iteration_(\d+|nil)$/ }.first
      if Story.reorder( param_to_use.last,
                        :iteration_id => eval( param_to_use.first.scan( /^iteration_(\d+|nil)$/ ).flatten.first ) )
        format.js { render_notice "Priorities have been successfully updated." }
      else
        format.js do
          render_error "There was an error while updating priorties. If the problem persists, please contact technical support." do |page|
            #TODO: If unsuccessful, replace the stories list
            #page.replace_html "stories", ""
          end
        end
      end
    end
  end
  
  def take
    @story = @project.stories.find(params[:id])
    @story.responsible_party = User.current_user
    
    respond_to do |format|
      if @story.save
        format.js do
          render_notice  %("#{@story.summary}" was successfully taken.) do |page|
            page["story_#{@story.id}_header"].replace_html( :partial=>"stories/release", :locals=>{:story=>@story})
          end
        end
      else
        format.js do
          render_error %("#{@story.summary}" was not successfully taken.)
        end        
      end
    end
  end

  def release
    @story = @project.stories.find(params[:id])
    @story.responsible_party = nil
    
    respond_to do |format|
      if @story.save
        format.js do
          render_notice  %("#{@story.summary}" was successfully released.) do |page|
            page["story_#{@story.id}_header"].replace_html( :partial=>"stories/take", :locals=>{:story=>@story})
          end
        end
      else
        format.js do
          render_error %("#{@story.summary}" was not successfully released.)
        end        
      end
    end
  end

  # PUT /stories/1;update_points.js
  def update_points
    @story = @project.stories.find(params[:id])
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

  # PUT /stories/1;update_status.js
  def update_status
    @story = @project.stories.find(params[:id])
    old_status_id = @story.status_id
    @story.status_id = params[:story][:status_id]

    respond_to do |format|
      if @story.save
        format.js do
          render_notice %("#{@story.summary}" was successfully updated.) do |page|
            page["story_#{@story.id}_status_#{@story.status_id}"].addClassName( "selected" )
            page["story_#{@story.id}_status_#{old_status_id}"].removeClassName( "selected" ) if old_status_id and old_status_id != @story.status_id
          end
        end
      else
        format.js do
          render_error %("#{@story.summary}" was not successfully updated.)
        end
      end
    end
  end
  
  def time
    @story = @project.stories.find(params[:id])
    @time_entry = @project.time_entries.build( params[:time_entry] )
    
    if request.post?
      @time_entry.timeable = @story
      if @time_entry.save
        format.js do
          #render_notice %(Time entry was successfully created.) do |page|
          #  page["story_#{@story.id}_time_list"].replace_html( @story.points || "&infin;" )
          #end
        end
      end
    end    
  end

  private

  def find_priorities_and_statuses
    @statuses = Status.find( :all ).map{ |s| [ s.name, s.id ] }.unshift []
    @priorities = Priority.find( :all ).map{ |e| [ e.name, e.id ] }.unshift []
  end

  def find_project
    @project = Project.find( params[:project_id] )#, :include => { :iterations => { :stories => :tags } } )
  end
end
