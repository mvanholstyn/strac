class UsersController < ApplicationController
  acts_as_login_controller

  redirect_after_login do
    { :controller => "example" }
  end
end
