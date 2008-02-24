class StoriesController < ApplicationController
  include ERB::Util
  
  in_place_edit_for :story, :points
  
  before_filter :find_project, :except => [ :update_points ]
  before_filter :find_priorities_and_statuses, :only => [ :new, :edit ]

  helper :comments

  def index
    @stories_presenter = StoriesIndexPresenter.new(:project => @project, :view => params['view'])
  end

  def show
    @story = @project.stories.find(params[:id], :include => [:tags, :comments] )
    @comments = @story.comments
    should_render_comment_links = false

    respond_to :html, :js
  end

  def new
    @story = @project.stories.build :bucket_id => params[:bucket_id]
    respond_to :js
  end
  
  def edit
    @story = @project.stories.find(params[:id], :include => :tags)
    respond_to do |format|
      format.html
      format.js { render :action => 'edit' }
    end
  end

  def create
    @story = @project.stories.build(params[:story])

    respond_to do |format|
      if @story.save
        format.js do
          find_priorities_and_statuses
        end
      else
        format.js do
          find_priorities_and_statuses
          render :action => "new"
        end
      end
    end
  end

  def update
    @story = @project.stories.find(params[:id], :include => :tags)

    respond_to do |format|
      if @story.update_attributes(params[:story])
        #TODO: If this stories iteration is changed, then it should move
        format.html do 
          flash[:notice] = %("#{h(@story.summary)}" was successfully updated.)
          redirect_to story_path(@project, @story)
        end
        format.js { render :template => "stories/update.js.rjs" }
      else
        format.html do
          render :action => 'edit'
        end
        format.js do
          find_priorities_and_statuses
          render :template => "stories/edit.js.rjs"
        end
      end
    end
  end

  def destroy
    @story = @project.stories.find(params[:id], :include => :tags)
    @story.destroy
  
    respond_to do |format|
      format.js
      format.html do
        flash[:notice] = %("#{@story.summary}" was successfully destroyed.)
        redirect_to stories_url(@project)
      end
    end
  end

  def reorder
    respond_to do |format|
      #TODO: Update zebra striping...
      #TODO: This will fail if complete stories are hidden..."
      param_to_use = params.select { |k,v| k =~ /^iteration_(\d+|nil)$/ }.first
      if Story.reorder(param_to_use.last, :bucket_id => eval(param_to_use.first.scan(/^iteration_(\d+|nil)$/).flatten.first))
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
    
    if @story.save
      render_notice %("#{@story.summary}" was successfully taken.) do |page|
        page["story_#{@story.id}_header"].replace_html :partial => "stories/release", :locals => { :story => @story }
      end
    else
      render_error %("#{@story.summary}" was not successfully taken.)
    end
  end

  def release
    @story = @project.stories.find(params[:id])
    @story.responsible_party = nil
    
    if @story.save
      render_notice %("#{@story.summary}" was successfully released.) do |page|
        page["story_#{@story.id}_header"].replace_html :partial => "stories/take", :locals => { :story => @story }
      end
    else
      render_error %("#{@story.summary}" was not successfully released.)
    end
  end
  
  def update_points
    render :update do |page|
      project_manager = ProjectManager.new(params[:project_id], current_user)
      project_manager.update_story_points(params[:id], params[:story][:points]) do |story_update|
        story_update.success do |story|
          project = story.project
          renderer = RemoteProjectRenderer.new(:page => page, :project => project)
          renderer.render_notice %("#{story.summary} was successfully updated.")
          renderer.update_story_points(story)
          renderer.update_project_summary
          renderer.draw_current_iteration_velocity_marker(project.average_velocity)
        end
        
        story_update.failure do |story|
          renderer = RemoteProjectRenderer.new(:page => page, :project => story.project)
          renderer.render_error %("#{story.summary}" was not successfully updated.)
        end
      end
    end
  end
  
  def update_status
    @story = @project.stories.find(params[:id])
    old_status_id = @story.status_id
    @story.status_id = params[:story][:status_id]

    if @story.save
      render_notice %("#{@story.summary}" was successfully updated.) do |page|
        page["story_#{@story.id}_status_#{@story.status_id}"].addClassName("selected")
        page["story_#{@story.id}_status_#{old_status_id}"].removeClassName("selected") if old_status_id and old_status_id != @story.status_id
      end
    else
      render_error %("#{@story.summary}" was not successfully updated.)
    end
  end
  
  def time
    @story = @project.stories.find(params[:id])
    @time_entry = @project.time_entries.build(params[:time_entry])
    
    if request.post?
      @time_entry.timeable = @story
      if @time_entry.save
        #render_notice %(Time entry was successfully created.) do |page|
        #  page["story_#{@story.id}_time_list"].replace_html(@story.points || "&infin;")
        #end
      end
    else
      respond_to :js
    end
  end

private

  def find_priorities_and_statuses
    @statuses = Status.find(:all).map{ |s| [s.name, s.id] }.unshift []
    @priorities = Priority.find(:all).map{ |e| [e.name, e.id] }.unshift []
  end

  def find_project
    @project = ProjectManager.get_project_for_user(params[:project_id], current_user)
  end
end
