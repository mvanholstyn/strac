require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/_signup.html.erb" do

  def render_it
    render :partial => "/users/signup.html.erb", :locals => { :user => @user }
  end
  
  def in_the_signup_form(&blk)
    response.should have_tag("form#signup"), &blk
  end
  alias_method :see_the_signup_form, :in_the_signup_form
  
  before do
    @user = mock_model(User)
  end

  it "renders a signup form" do
    render_it  
    see_the_signup_form
  end
  
  it "has a email address text field" do
    render_it
    in_the_signup_form do
      response.should have_tag("input[type=text][id=user_email_address]")
    end
  end
  
  it "has a password field" do
    render_it
    in_the_signup_form do
      response.should have_tag("input[type=password][id=user_password]")
    end
  end
  
  it "has a password confirmation field" do
    render_it
    in_the_signup_form do
      response.should have_tag("input[type=password][id=user_password_confirmation]")
    end
  end
end
