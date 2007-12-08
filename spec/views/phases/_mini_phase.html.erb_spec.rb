require File.dirname(__FILE__) + '/../../spec_helper'

describe "/phases/_mini_phase.html.erb" do
  def render_it
    render :partial => "/phases/mini_phase", :locals => { :phase => @phase }
  end
  
  before do
    @phase = mock_model(Phase, :new_record? => true, :name => "", :project => @project)
  end

  it "renders the phase" do
    @phase.should_receive(:name).at_least(1).times.and_return("Foo & Bar & Phase")
    render_it
    response.should have_tag("#phase_#{@phase.id}", h(@phase.name).to_regexp)
  end
  
end


