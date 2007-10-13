require File.dirname(__FILE__) + '/../../spec_helper'

describe "/invitations/new.html.erb" do
  
  before do
    @project = mock_model(Project)
    @invitation = mock_new_model(Invitation)
    
    assigns[:project] = @project
    assigns[:invitation] = @invitation
    
    render "/invitations/new.html.erb"
  end

  it "should have a form to create a new invitation" do
    response.should have_tag("form[id=new_invitation][method=post][action=?]", project_invitations_path(@project))
  end


  it "should have an email_addresses text area" do
    within_form do
      with_tag "textarea[name=?]", "email_addresses"
    end
  end

  it "should have an email_body text area" do
    within_form do
      with_tag "textarea[name=?]", "email_body"
    end
  end
  
  it "has a submit button" do
    within_form do
      with_tag "input[type=submit]"
    end    
  end

  def within_form &block
    response.should have_tag("form"), &block
  end
end


