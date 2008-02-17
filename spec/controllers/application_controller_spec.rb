require File.dirname(__FILE__) + '/../spec_helper'

# Re-raise errors caught by the controller.
class FakeController < ApplicationController
  attr_reader :the_time_zone
  
  def index
    render :inline => "fake index"
  end
  
  def raise_access_denied
    raise AccessDenied
  end

  def rescue_action(e)
    raise e
  end
end

describe ApplicationController, 'when AccessDenied is raised' do
  controller_name 'Fake'

  after do
    eval IO.read(RAILS_ROOT + "/config/routes.rb")
  end

  before do
    ActionController::Routing::Routes.draw do |map|
      map.fakeindex 'index',  :controller => 'fake', :action => 'index'
      map.raise_access_denied '/raise_access_denied', :controller => 'fake', :action => 'raise_access_denied'
    end
    @user = mock_model(User)
    login_as @user
  end

  it "redirects to the /access_denied.html page" do
    get :raise_access_denied
    response.should redirect_to("/access_denied.html")
  end
end