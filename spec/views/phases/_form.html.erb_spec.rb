require File.dirname(__FILE__) + '/../../spec_helper'

describe "/phases/_form.html.erb" do
  def render_it
    render :partial => "phases/form.html.erb", :locals => { :phase => @phase }
  end

  before do
    @project = mock_model(Project)
    @phase = mock_model(Phase, 
      :project => @project, 
      :name => nil, 
      :description => nil)
    template.stub!(:error_messages_for)
  end

  it "renders errors for the phase" do
    template.should_receive(:error_messages_for).with(:phase).and_return(%|<p id="phase_errors" />|)
    render_it
    response.should have_tag('p#phase_errors')
  end
  
  it "renders a form to create a Phase" do
    render_it
    response.should have_tag('form[action=?]', project_phase_path(@project, @phase))
  end
  
  describe "create a Phase form" do
    it "has a name text field" do
      render_it
      response.should have_tag('input[type=text][id=?]', 'phase_name')
    end
    
    it "has a description text area" do
      render_it
      response.should have_tag('textarea[id=?]', 'phase_description')
    end
    
    it "has a submit button" do
      render_it
      response.should have_tag('input[type=submit]')
    end
  end

end