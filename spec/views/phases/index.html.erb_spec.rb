require File.dirname(__FILE__) + '/../../spec_helper'

describe "/phases/index.html.erb" do
  def render_it
    assigns[:phases] = @phases
    assigns[:project] = @project
    render "phases/index.html.erb"
  end
  
  before do
    @project = mock_model(Project)
    @phases = [ mock_model(Phase, :name => nil), mock_model(Phase, :name => nil) ]
  end
  
  it "renders the name of each phase" do
    @phases.first.should_receive(:name).and_return("Foo")
    @phases.last.should_receive(:name).and_return("Bar")
    render_it
    response.should have_text("Foo".to_regexp)
    response.should have_text("Bar".to_regexp)
  end
  
  it "renders a link to each phase" do
    render_it
    response.should have_tag('a[href=?]', project_phase_path(@project, @phases.first))
    response.should have_tag('a[href=?]', project_phase_path(@project, @phases.last))
  end
  
  it "renders a link to each phase's edit page" do
    render_it
    response.should have_tag('a[href=?]', edit_project_phase_path(@project, @phases.first))
    response.should have_tag('a[href=?]', edit_project_phase_path(@project, @phases.last))    
  end
  
  it "renders a link to destroy each phase" do
    render_it
    response.should have_tag('a[href=?][onclick*=?]', project_phase_path(@project, @phases.first), "delete")
    response.should have_tag('a[href=?][onclick*=?]', project_phase_path(@project, @phases.last), "delete")
  end
  
  it "renders a link to create a new phase" do
    render_it
    response.should have_tag('a[href=?]', new_project_phase_path(@project))
  end
  
end