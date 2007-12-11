require File.dirname(__FILE__) + '/../spec_helper'

describe StoriesController, "user with privileges requesting #index " do
  def get_index
    get :index, { :project_id=>'1' }, {:current_user_id=>2}    
  end

  before do
    @user = mock_model(User)
    @project = mock_model(Project)
    @iterations = mock "iterations"

    StoriesController.login_model.stub!(:find).and_return(@user)
    @user.stub!(:has_privilege?).and_return(true)
    
    @project.stub!(:iterations_ordered_by_start_date)
    @project.stub!(:backlog_iteration)
    IterationsPresenter.stub!(:new)

    Project.stub!(:find).and_return(@project)
  end

  it "returns successful" do
    get_index
    response.should be_success
  end
  
  it "renders the index.html.erb template" do
    get_index
    response.should render_template("index")
  end
  
  it "assigns @iterations to a IterationsPresenter" do
    @iterations_presenter = mock "iterations presenter"
    @backlog_iteration = mock "backlog iteration"
    @project.should_receive(:iterations_ordered_by_start_date).and_return(@iterations)
    @project.should_receive(:backlog_iteration).and_return(@backlog_iteration)
    IterationsPresenter.should_receive(:new).with(
      :iterations => @iterations, 
      :backlog => @backlog_iteration,
      :project => @project).and_return(@iterations_presenter)
    get_index

    assigns[:iterations].should == @iterations_presenter
  end
    
end

describe StoriesController, '#edit' do
  def get_edit(attrs={})
    get :edit, {:project_id => '1', :id => '2'}.merge(attrs)
  end
  
  before do
    stub_login_for StoriesController
    @project = stub("project")
    @stories = stub("stories", :find => nil)
    Project.stub!(:find).and_return(@project)
    @project.stub!(:stories).and_return(@stories)
  end
  
  it "finds the requested story" do
    @project.should_receive(:stories).and_return(@stories)
    @stories.should_receive(:find).with('2', :include => :tags)
    get_edit
  end
  
  it "assigns @story" do
    story = stub("story")
    @stories.stub!(:find).and_return(story)
    get_edit
    assigns[:story].should == story
  end
  
  describe StoriesController, 'html request' do
    it "renders the 'edit' template" do
      get_edit
      response.should render_template('edit')
    end
  end
  
  describe StoriesController, 'xhr request' do
    it "renders the 'edit.js.rjs' template" do
      xhr :get, :edit, :project_id => '1', :id => '2'
      response.should render_template('stories/edit.js.rjs')
    end
  end
end

describe StoriesController, '#update' do
  def put_update(attrs={})
    put :update, {:project_id => '1', :id => '2', :story => @story_params}.merge(attrs)
  end
  
  before do
    stub_login_for StoriesController
    @story = stub("story", :update_attributes => true, :summary => "foo")
    @stories = stub("stories", :find => @story)
    @project = stub("project", :stories => @stories)
    @story_params = { 'summary' => 'foo' }
    Project.stub!(:find).and_return(@project)
  end
  
  it "finds the requested story" do
    @project.should_receive(:stories).and_return(@stories)
    @stories.should_receive(:find).with('2', :include => :tags).and_return(@story)
    put_update
  end
  
  it "assigns @story" do
    @stories.stub!(:find).and_return(@story)
    put_update
    assigns[:story].should == @story
  end
  
  it "updates the story" do
    @story.should_receive(:update_attributes).with(@story_params)
    put_update
  end
  
  describe StoriesController, "updating the story successfully" do
    before do
      @story.stub!(:update_attributes).and_return(true)
    end
    
    describe StoriesController, 'html request' do
      it "redirects to the story_path" do
        put_update
        response.should redirect_to(story_path(@project, @story))
      end
      
      it "sets a flash[:notice] message" do
        put_update
        flash[:notice].should_not be_nil
      end
    end
  
    describe StoriesController, 'xhr request' do
      it "renders the 'update.js.rjs' template" do
        xhr :put, :update, :project_id => '1', :id => '2', :story => @story_params
        response.should render_template('stories/update.js.rjs')
      end
    end
  end
  
  describe StoriesController, "failing to update the story" do
    before do
      @story.stub!(:update_attributes).and_return(false)
    end
    
    describe StoriesController, 'html request' do
      it "renders the 'edit' template" do
        put_update
        response.should render_template('edit')
      end
    end
  
    describe StoriesController, 'xhr request' do
      before do
        @statuses = [stub("status1", :id => 1, :name => "a"), stub("status2", :id => 2, :name => "b")]
        Status.stub!(:find).and_return(@statuses)
        @priorities = [stub("priority1", :id => 1, :name => "f"), stub("priority2", :id => 2, :name => "g")]
        Priority.stub!(:find).and_return(@priorities)
      end
      
      it "renders the 'edit.js.rjs' template" do
        xhr :put, :update, :project_id => '1', :id => '2', :story => @story_params
        response.should render_template('stories/edit.js.rjs')
      end

      it "finds all statuses" do
        Status.should_receive(:find).with(:all).and_return(@statuses)
        xhr :put, :update, :project_id => '1', :id => '2', :story => @story_params
      end
      
      it "assigns @statuses" do
        xhr :put, :update, :project_id => '1', :id => '2', :story => @story_params
        assigns[:statuses].should == [[], ["a", 1], ["b", 2]]
      end
      
      it "finds all priorities" do
        Priority.should_receive(:find).with(:all).and_return(@priorities)
        xhr :put, :update, :project_id => '1', :id => '2', :story => @story_params
      end
      
      it "assigns @priorities" do
        xhr :put, :update, :project_id => '1', :id => '2', :story => @story_params
        assigns[:priorities].should == [[], ["f", 1], ["g", 2]]
      end
    end

  end
end


__END__
  def update
    @story = @project.stories.find(params[:id], :include => :tags)

    respond_to do |format|
      if @story.update_attributes(params[:story])
        #TODO: If this stories iteration is changed, then it should move
        format.js
        format.xml { head :ok }
      else
        format.js do
          find_priorities_and_statuses
          render :action => "edit"
        end
        format.xml { render :xml => @story.errors.to_xml }
      end
    end
  end
