require File.dirname(__FILE__) + '/../../spec_helper'

describe "/phases/_form.html.erb" do
  def render_it
    render :partial => "/phases/form", :locals => { :phase => @phase }
  end
  
  before do
    @project = mock_model(Project)
    @phase = mock_model(Phase, :new_record? => true, :name => "", :project => @project)
    template.stub!(:error_messages_for)
  end
  
  it "renders errors on phase" do
    template.should_receive(:error_messages_for).with(:phase).and_return(%|<p id="the_errors" />|)
    render_it
    response.should have_tag('p#the_errors')
  end

  it "renders the new form" do
    render_it
    response.should have_tag("form.new_phase[method=post][id=phase_form][action=?]", project_phases_path(@project))
  end

  describe "the new phase form" do
    it "has a name text field" do
      @phase.should_receive(:name).and_return("")
      render_it
      response.should have_tag("form.new_phase input[type=text][id=?]", "phase_name")
    end
    
    it "has a submit button" do
      render_it
      response.should have_tag("form.new_phase input[type=submit]")
    end
  end
end


