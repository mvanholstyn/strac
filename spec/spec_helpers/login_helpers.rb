class Spec::Rails::Example::ControllerExampleGroup
  def login_as(user)
    if user.is_a?(String) || user.is_a?(Symbol)
      user = users(user)
    end
    @request.session[:current_user_id] = user.id
    User.current_user = user
  end 

end