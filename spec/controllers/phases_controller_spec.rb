require File.dirname(__FILE__) + '/../spec_helper'

describe PhasesController, "#index" do
  def get_index(attrs={})
    get :index, {:project_id => '1'}.merge(attrs)
  end
  
  before do
    stub_login_for PhasesController
    @project = stub("project")
    @phases = stub("phases", :find => nil)
    Project.stub!(:find).and_return(@project)
    @project.stub!(:phases).and_return(@phases)
  end
  
  it "finds all phases for the current project" do
    @project.should_receive(:phases).and_return(@phases)
    @phases.should_receive(:find).with(:all, :order => "name")
    get_index
  end
  
  it "assigns @phases" do
    @phases.stub!(:find).and_return(:result)
    get_index
    assigns[:phases].should == :result
  end
  
  describe "html request" do
    it "renders the index template" do
      get_index 
      response.should render_template("index")
    end
  end
  
  describe "xml request" do
    before do
      @phase_array = stub("array of phases")
      @phases.stub!(:find).and_return(@phase_array)
    end
    
    it "renders an xml response" do
      @phase_array.should_receive(:to_xml).and_return(:foo)
      controller.expect_render(:xml => :foo)
      get_index 'format' => 'xml'
    end
  end
end

describe PhasesController, "#new" do
  def get_new
    get :new, :project_id => '1'
  end
  
  before do
    stub_login_for PhasesController
    @project = stub("project")
    @phases = stub("phases")
    Project.stub!(:find).and_return(@project)
    @project.stub!(:phases).and_return(@phases)    
  end
  
  it "builds a new phase" do
    @project.should_receive(:phases).and_return(@phases)
    @phases.should_receive(:build)
    get_new
  end
  
  it "assigns @phase" do
    @phases.stub!(:build).and_return(:phase)
    get_new
    assigns[:phase].should == :phase
  end
end

describe PhasesController, "#create" do
  def post_create
    post :create, 'project_id' => '1', 'phase' => @phase_params
  end
  
  before do
    stub_login_for PhasesController
    @phase = mock_model(Phase, :save => true)
    @phases = stub("phases", :build => @phase)
    @project = mock_model(Project, :phases => @phases)
    Project.stub!(:find).and_return(@project)
    @phase_params = { 'name' => 'FooBaz', 'description' => 'FooDesc' }
  end
  
  it "builds a phase from the passed in parameters" do
    @project.should_receive(:phases).and_return(@phases)
    @phases.should_receive(:build).with(@phase_params).and_return(@phase)
    post_create
  end
  
  describe PhasesController, "saving the phase successfully" do
    before do
      @phase.should_receive(:save).and_return(true)
    end
    
    it "sets a flash[:notice] message" do
      post_create
      flash[:notice].should_not be_nil
    end
    
    it "redirects to the newly created phase page" do
      post_create
      response.should redirect_to(project_phase_path(@project, @phase))
    end
  end

  describe PhasesController, "saving the phase unsuccessfully" do
    before do
      @phase.should_receive(:save).and_return(false)
    end
    
    it "sets a flash[:error] message" do
      post_create
      flash[:error].should_not be_nil
    end
    
    it "renders the 'new' template" do
      post_create
      response.should render_template('new')
    end
  end
end


describe PhasesController, "#show" do
  def get_show(attrs={})
    get :show, {:project_id => '1', :id => '2'}.merge(attrs)
  end
  
  before do
    stub_login_for PhasesController
    @phase = mock_model(Phase)
    @phases = stub("phases", :find => @phase)
    @project = mock_model(Project, :phases => @phases)
    Project.stub!(:find).and_return(@project)
  end
  
  it "finds the current phase" do
    @project.should_receive(:phases).and_return(@phases)
    @phases.should_receive(:find).with('2')
    get_show
  end
  
  it "assigns @phase" do
    get_show
    assigns[:phase].should == @phase
  end
  
  describe "html request" do
    it "rendres the show template" do
      get_show
      response.should render_template('show')
    end
  end
  
  describe "xml request" do
    it "renders the phase as xml" do
      @phase.should_receive(:to_xml).and_return(:foo)
      controller.expect_render(:xml => :foo)
      get_show 'format' => 'xml'
    end
  end
end

describe PhasesController, "#edit" do
  def get_edit
    get :edit, :project_id => '1', :id => '2'
  end
  
  before do
    stub_login_for PhasesController
    @phase = mock_model(Phase)
    @phases = stub("phases", :find => @phase)
    @project = mock_model(Project, :phases => @phases)
    Project.stub!(:find).and_return(@project)    
  end
  
  it "finds the phase" do
    @project.should_receive(:phases).and_return(@phases)
    @phases.should_receive(:find).with('2')
    get_edit
  end
  
  it "assigns @phase" do
    @phases.stub!(:find).and_return(@phase)
    get_edit
    assigns[:phase].should == @phase
  end
  
  it "renders the edit template" do
    get_edit
    response.should render_template('edit')
  end
end


describe PhasesController, "#update" do
  def put_update
    put :update, :project_id => '1', :id => '2', :phase => @phase_params
  end
  
  before do
    stub_login_for PhasesController
    @phase = mock_model(Phase, :update_attributes => true)
    @phases = stub("phases", :find => @phase)
    @project = mock_model(Project, :phases => @phases)
    Project.stub!(:find).and_return(@project)        
    @phase_params = { 'name' => 'foo', 'description' => 'bar' }
  end
  
  it "finds the phase" do
    @project.should_receive(:phases).and_return(@phases)
    @phases.should_receive(:find).with('2').and_return(@phase)
    put_update
  end
  
  it "assigns @phase" do
    @phases.stub!(:find).and_return(@phase)
    put_update
    assigns[:phase].should == @phase
  end
  
  it "updates the phase" do
    @phase.should_receive(:update_attributes).with(@phase_params)
    put_update
  end
  
  describe PhasesController, "when updating fails" do
    before do
      @phase.stub!(:update_attributes).and_return(false)
    end
    
    it "renders the edit template" do
      put_update
      response.should render_template('edit')
    end
  end
  
  describe PhasesController, "when updating succeeds" do
    before do
      @phase.stub!(:update_attributes).and_return(true)
    end
    
    it "sets a flash[:notice] message" do
      put_update
      flash[:notice].should_not be_nil
    end
    
    it "redirects to the project phase path" do
      put_update
      response.should redirect_to(project_phase_path(@project, @phase))
    end
  end
end

describe PhasesController, "#destroy" do
  def delete_destroy
    delete :destroy, :project_id => '1', :id => '2'
  end
  
  before do
    stub_login_for PhasesController
    @phase = mock_model(Phase, :destroy => nil)
    @phases = stub("phases", :find => @phase)
    @project = mock_model(Project, :phases => @phases)
    Project.stub!(:find).and_return(@project)        
  end

  it "finds the phase" do
    @project.should_receive(:phases).and_return(@phases)
    @phases.should_receive(:find).with('2').and_return(@phase)
    delete_destroy
  end
  
  it "assigns the phase" do
    @phases.stub!(:find).and_return(@phase)
    delete_destroy
    assigns[:phase].should == @phase
  end
  
  it "destroys the phase" do
    @phase.should_receive(:destroy)
    delete_destroy
  end
  
  it "redirects to the project phases path" do
    delete_destroy
    response.should redirect_to(project_phases_path(@project))
  end
  
end

