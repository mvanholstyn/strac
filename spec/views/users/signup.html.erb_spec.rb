require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/signup.html.erb" do
  include StoriesHelper
  
  before do
    @story = mock_model(User)

    assigns[:user] = @user
  end

  it "should render a signup form" do
     render "/users/signup.html.erb"
     response.should have_tag("form#signup")
  end
end
