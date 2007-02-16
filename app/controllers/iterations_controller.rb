class IterationsController < ApplicationController
  # GET /iterations
  # GET /iterations.xml
  def index
    @iterations = Iteration.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @iterations.to_xml }
    end
  end

  # GET /iterations/1
  # GET /iterations/1.xml
  def show
    @iteration = Iteration.find(params[:id])

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
    @iteration = Iteration.find(params[:id])
  end

  # POST /iterations
  # POST /iterations.xml
  def create
    @iteration = Iteration.new(params[:iteration])

    respond_to do |format|
      if @iteration.save
        flash[:notice] = 'Iteration was successfully created.'
        format.html { redirect_to iteration_url(@iteration) }
        format.xml  { head :created, :location => iteration_url(@iteration) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @iteration.errors.to_xml }
      end
    end
  end

  # PUT /iterations/1
  # PUT /iterations/1.xml
  def update
    @iteration = Iteration.find(params[:id])

    respond_to do |format|
      if @iteration.update_attributes(params[:iteration])
        flash[:notice] = 'Iteration was successfully updated.'
        format.html { redirect_to iteration_url(@iteration) }
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
    @iteration = Iteration.find(params[:id])
    @iteration.destroy

    respond_to do |format|
      format.html { redirect_to iterations_url }
      format.xml  { head :ok }
    end
  end
end
