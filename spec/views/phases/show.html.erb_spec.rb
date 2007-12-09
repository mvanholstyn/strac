require File.dirname(__FILE__) + '/../../spec_helper'

describe "/phases/show.html.erb" do
  def render_it
    assigns[:phase] = @phase
    render "phases/show.html.erb"
  end
  
  before do
    @stories = stub("stories")
    @phase = mock_model(Phase, :name => nil, :description => nil, :stories => @stories)
    template.stub_render(:partial => "stories/list", :locals => { :stories => @stories }) 
  end
  
  it "renders the phase's name" do
    @phase.should_receive(:name).and_return("bazooka joe")
    render_it
    response.should have_text("bazooka joe".to_regexp)
  end
  
  it "renders the phase's description" do
    @phase.should_receive(:description).and_return("bubble gum")
    render_it
    response.should have_text("bubble gum".to_regexp)    
  end

  it "renders the stories/list partial" do
    template.expect_render(:partial => "stories/list", :locals => { :stories => @stories }).and_return(%|<p id="stories_list" />|)
    render_it
    response.should have_tag('p#stories_list')
  end
end
