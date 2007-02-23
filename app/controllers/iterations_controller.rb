class IterationsController < ApplicationController
  before_filter :find_project

  # GET /iterations
  # GET /iterations.xml
  def index
    @iterations = @project.iterations.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @iterations.to_xml }
    end
  end

  # GET /iterations/1
  # GET /iterations/1.xml
  def show
    @iteration = @project.iterations.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @iteration.to_xml }
    end
  end

  # GET /iterations/new
  def new
    @iteration = Iteration.new
  end

  # GET /iterations/1;edit
  def edit
    @iteration = @project.iterations.find(params[:id])
  end

  # POST /iterations
  # POST /iterations.xml
  def create
    @iteration = Iteration.new(params[:iteration])

    respond_to do |format|
      if @iteration.save
        flash[:notice] = 'Iteration was successfully created.'
        format.html { redirect_to iteration_url(@project, @iteration) }
        format.xml  { head :created, :location => iteration_url(@project, @iteration) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @iteration.errors.to_xml }
      end
    end
  end

  # PUT /iterations/1
  # PUT /iterations/1.xml
  def update
    @iteration = @project.iterations.find(params[:id])

    respond_to do |format|
      if @iteration.update_attributes(params[:iteration])
        flash[:notice] = 'Iteration was successfully updated.'
        format.html { redirect_to iteration_url(@project, @iteration) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @iteration.errors.to_xml }
      end
    end
  end

  # DELETE /iterations/1
  # DELETE /iterations/1.xml
  def destroy
    @iteration = @project.iterations.find(params[:id])
    @iteration.destroy

    respond_to do |format|
      format.html { redirect_to iterations_url( @project ) }
      format.xml  { head :ok }
    end
  end

  private

  def find_project
    @project = Project.find( params[:project_id] )
  end
end
