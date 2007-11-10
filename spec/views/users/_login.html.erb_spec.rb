require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/_login.html.erb" do

  def render_it
    render :partial => "/users/login.html.erb", :locals => { :user => @user }
  end
  
  def in_the_login_form(&blk)
    response.should have_tag("form#login_form"), &blk
  end
  alias_method :see_the_login_form, :in_the_login_form
  
  before do
    @user = mock_model(User, :email_address => "foo@example.com", :password => "")
  end

  it "has a login form" do
    render_it
    see_the_login_form
  end

  it "has a text field for an email address" do
    render_it
    in_the_login_form do
      response.should have_tag("input[type=text][id=user_email_address]")
    end
  end
  
  it "has a password field for the password" do
    render_it
    in_the_login_form do
      response.should have_tag("input[type=password][id=user_password]")
    end
  end
  
  it "has a remember me checkbox" do
    render_it
    in_the_login_form do 
      response.should have_tag("input[type=checkbox][id=remember_me]")
    end
  end
  
  it "should contain a submit button" do
    render_it
    in_the_login_form do
      response.should have_tag("input[type=submit]")
    end
  end
  
end
