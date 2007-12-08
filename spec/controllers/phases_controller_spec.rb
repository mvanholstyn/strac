require File.dirname(__FILE__) + '/../spec_helper'

describe PhasesController, '#index' do
  def get_index
    get :index, {:project_id => '1'}, {:current_user_id=>2}
  end
  
  before do
    stub_login_for PhasesController
    @project = stub("project", :phases => nil)
    Project.stub!(:find).and_return(@project)
  end
  
  it "finds and assigns @project" do
    Project.should_receive(:find).with('1').and_return(@project)
    get_index
    assigns[:project].should == @project
  end
  
  it "finds and assigns all @phases for the project" do
    @phases = stub("phases")
    @project.should_receive(:phases).and_return(@phases)
    get_index
    assigns[:phases] = @phases
  end
  
  it "renders the index template" do
    get_index
    response.should render_template('index')
  end

end

describe PhasesController, '#new xhr call' do
  def get_new
    xhr :get, :new, {:project_id => '11'}, {:current_user_id=>2}
  end

  before do
    stub_login_for PhasesController
    @phase = stub("phase")
    @phases = stub("phases", :build => nil )
    @project.stub!(:phases).and_return(@phases)
    Project.stub!(:find).and_return(@project)
    Phase.stub!(:new)
  end
  
  it "assigns a new @phase" do
    @project.should_receive(:phases).and_return(@phases)
    @phases.should_receive(:build).and_return(@phase)
    get_new
    assigns[:phase].should == @phase
  end
  
  it "renders the new.js.rjs template" do
    get_new
    response.should render_template("new.js.rjs")
  end

end


describe PhasesController, '#create xhr' do
  def post_create
    xhr :post, :create, { :project_id => '11', :phase => {:name => 'foo'} }, {:current_user_id=>2}
  end
  
  before do
    stub_login_for PhasesController
    @phase = stub("phase", :save => true)
    @phases = stub("phases", :build => @phase )
    @project.stub!(:phases).and_return(@phases)
    Project.stub!(:find).and_return(@project)
  end

  it "creates a new phase" do
    @project.should_receive(:phases).and_return(@phases)
    @phases.should_receive(:build).with('name' => 'foo').and_return(@phase)
    post_create
  end

  it "renders the create.js.rjs template" do
    @phase.should_receive(:save).and_return(true)
    post_create
    response.should render_template('create.js.rjs')
  end

  describe PhasesController, "saving the new phase successfully" do    
    it "renders a flash notice" do
      post_create
      flash[:notice].should == "The phase has been created successfully"
    end
  end
  
  describe PhasesController, "unable to save the new phase" do
    it "renders a flash error" do
      @phase.should_receive(:save).and_return(false)
      post_create
      flash[:error].should == "The phase could not be created."
    end
  end
  
end
