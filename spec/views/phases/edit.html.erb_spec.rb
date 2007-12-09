require File.dirname(__FILE__) + '/../../spec_helper'

describe "/phases/edit.html.erb" do
  def render_it
    assigns[:phase] = @phase
    assigns[:project] = @project
    render "phases/edit.html.erb"
  end
  
  before do
    @phase = mock_model(Phase)
    @project = mock_model(Project)
    template.stub_render(:partial => "phases/form", :locals => { :phase => @phase })
  end
  
  it "renders the phases/form partial" do
    template.expect_render(:partial => "phases/form", :locals => { :phase => @phase }).and_return(%|<p id="form_partial" />|)    
    render_it
    response.should have_tag('p#form_partial')
  end
  
  it "renders a link to the phases list" do
    render_it
    response.should have_tag('a[href=?]', project_phases_path(@project))
  end
  
end
