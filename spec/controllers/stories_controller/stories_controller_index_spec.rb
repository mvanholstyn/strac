require File.dirname(__FILE__) + '/../../spec_helper'

describe StoriesController, "user with privileges requesting #index " do
  def get_index(attrs={})
    get :index, {:project_id=>'1'}.merge(attrs), {:current_user_id=>2}    
  end

  before do
    @user = mock_model(User)
    @project = mock_model(Project)
    StoriesController.login_model.stub!(:find).and_return(@user)
    @user.stub!(:has_privilege?).and_return(true)
    @stories_index_presenter = stub("story index presenter")
    StoriesIndexPresenter.stub!(:new).and_return(@stories_index_presenter)
    ProjectManager.stub!(:get_project_for_user).and_return(@project)
  end

  it "returns successful" do
    get_index
    response.should be_success
  end

  it "creates a StoriesIndexPresenter" do
    StoriesIndexPresenter.should_receive(:new).with(
      anything
    ).and_return(@stories_index_presenter)
    get_index
  end
  
  it "assigns @project" do
    get_index
    assigns[:project].should == @project
  end
  
  it "assigns @stories_presenter" do
    StoriesIndexPresenter.stub!(:new).and_return(@stories_index_presenter)
    get_index
    assigns[:stories_presenter].should == @stories_index_presenter
  end
  
  it "renders the index.html.erb template" do
    get_index
    response.should render_template("index")
  end
  
  describe "creating the StoriesIndexPresenter" do
    it "passes in a the current @project into the StoriesIndexPresenter constructor" do
      StoriesIndexPresenter.should_receive(:new).with(
        has_entry(:project, @project)
      ).and_return(@stories_index_presenter)
      get_index
    end

    describe "when a :view parameter is passed in" do
      it "passes params['view'] into the StoriesIndexPresenter constructor" do
        view = "foo"
        StoriesIndexPresenter.should_receive(:new).with(
          has_entry(:view, view)
        ).and_return(@stories_index_presenter)
        get_index :view => view
      end
    end
  end
 
end