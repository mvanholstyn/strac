class UsersController < ApplicationController
  acts_as_login_controller :allow_signup => true

  redirect_after_login do
    { :controller => "example" }
  end
end
