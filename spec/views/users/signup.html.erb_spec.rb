require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/signup.html.erb" do

  def render_it
    render "/users/signup.html.erb"
  end
  
  before do
    @user = stub("user")
    assigns[:user] = @user
    
    template.expect_render(
      :partial => "users/signup", :locals => { :user => @user }
    ).and_return(%|<p id="signup_partial" />|)
  end
  
  it "renders the /users/_signup.html.erb partial" do
    render_it
    response.should have_tag("#signup_partial")
  end
  
end