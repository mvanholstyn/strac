require File.dirname(__FILE__) + '/../../spec_helper'

describe "/iterations/_list.html.erb" do
  before do
    @iterations = mock "iterations"
    template.expect_render(:partial => "iterations/iteration", :collection => @iterations).and_return(%|<p id="iteration-partial" />|)
    render :partial => "iterations/list", :locals => { :iterations => @iterations }
  end
  
  it "render the iterations/iteration partial with a collection of iterations" do
    response.should have_tag("#iteration-partial")
  end
end