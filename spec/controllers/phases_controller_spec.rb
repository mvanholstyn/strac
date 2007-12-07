require File.dirname(__FILE__) + '/../spec_helper'

describe PhasesController, '#index' do
  def get_index
    get :index, {:project_id => '1'}, {:current_user_id=>2}
  end
  
  before do
    @user = mock_model(User)
    @project = mock_model(Project)

    PhasesController.login_model.stub!(:find).and_return(@user)
    @user.stub!(:has_privilege?).and_return(true)
  end
  
  it "renders the index template" do
    get_index
    response.should render_template('index')
  end

end
