require File.dirname(__FILE__) + '/../../spec_helper'

describe "/phases/index.html.erb" do
  def render_it
    assigns[:project] = @project
    assigns[:phases] = @phases
    render "/phases/index.html.erb"
  end
  
  before do
    @phases = []
    @project = mock_model(Project)
    template.stub_render(:partial => "phases/mini_phase", :locals => {:phase => @phase})
  end

  it "renders a remote link to create a new story" do
    @project.should_receive(:id).and_return(98)
    render_it
    response.should have_tag("a.create_phase[onclick*=?]", new_project_phase_path(98))
  end

  it "renders a place holder for the new story form to go" do
    render_it
    response.should have_tag("#new_phase")
  end

  it "renders the phases list" do
    render_it
    response.should have_tag('#phases')
  end

  describe "the phases list" do
    it "renders the phases/mini_phase partial for each phase" do
      @phases = [ stub("phase 1"), stub("phase 2") ]
      template.expect_render(:partial => "phases/mini_phase", :locals => {:phase => @phases.first}).and_return(%|<p id="phase1" />|)
      template.expect_render(:partial => "phases/mini_phase", :locals => {:phase => @phases.last}).and_return(%|<p id="phase2" />|)
      render_it
      response.should have_tag('p#phase1')
      response.should have_tag('p#phase2')
    end
  end
  
end

