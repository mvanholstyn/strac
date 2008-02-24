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

  def raise_resource_not_found
    raise ResourceNotFoundError
  end

  def rescue_action(e)
    raise e
  end
end

describe ApplicationController, 'when exceptions are raised' do
  controller_name 'Fake'

  after do
    eval IO.read(RAILS_ROOT + "/config/routes.rb")
  end

  before do
    ActionController::Routing::Routes.draw do |map|
      map.fakeindex 'index',  :controller => 'fake', :action => 'index'
      map.raise_access_denied '/raise_access_denied', :controller => 'fake', :action => 'raise_access_denied'
      map.raise_resource_not_found '/raise_resource_not_found', :controller => 'fake', :action => 'raise_resource_not_found'
    end
    @user = mock_model(User)
    login_as @user
  end

  it "redirects to the /access_denied.html page when AccessDenied is raised" do
    get :raise_access_denied
    response.should redirect_to("/access_denied.html")
  end
  
  it "redirects to the /access_denied.html page when ResourceNotFoundError is raised" do
    get :raise_resource_not_found
    response.should redirect_to("/access_denied.html")    
  end
end