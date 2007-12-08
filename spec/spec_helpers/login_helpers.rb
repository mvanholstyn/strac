class Spec::Rails::Example::ControllerExampleGroup
  def stub_login_for(controller_klass)
    @user = mock_model(User)
    @project = mock_model(Project, :id => 91)

    controller_klass.login_model.stub!(:find).and_return(@user)
    @user.stub!(:has_privilege?).and_return(true)
  end
  
  def login_as(user)
    if user.is_a?(String) || user.is_a?(Symbol)
      user = users(user)
    end
    @request.session[:current_user_id] = user.id
    User.current_user = user
  end 
end