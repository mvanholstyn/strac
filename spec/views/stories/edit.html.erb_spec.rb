require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories/edit.html.erb" do
  def render_it
    assigns[:story] = @story
    render "stories/edit"
  end
  
  before do
    @story = mock_model(Story)
    template.stub_render :partial => "stories/edit", :locals => { :story => @story }
  end

  it "renders the stories/edit partial" do
    template.expect_render(:partial => "stories/edit", :locals => { :story => @story }).and_return(%|<p id="edit_partial" />|)
    render_it
  end
  
end


