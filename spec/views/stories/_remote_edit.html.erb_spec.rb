require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories/_remote_edit.html.erb" do
  def render_it
    render :partial => "stories/remote_edit", :locals => { :story => @story }
  end
  
  before do
    @project = mock_model(Project)
    @story = mock_model(Story, :project => @project)
    template.stub_render :partial => "stories/toolbar", :locals => { :story => @story }
    template.stub_render :partial => "stories/form", :locals => { :form => anything, :story => @story }
    template.stub!(:error_messages_for)
  end

  it "renders the stories/toolbar partial" do
    template.expect_render(:partial => "stories/toolbar", :locals => { :story => @story }).and_return(%|<p id="toolbar_partial" />|)
    render_it
    response.should have_tag('p#toolbar_partial')
  end
  
  it "renders errors messages for the story" do
    template.should_receive(:error_messages_for).with(:story).and_return(%|<p id="error_messages" />|)
    render_it
    response.should have_tag('p#error_messages')
  end

  it "renders an edit form" do
    render_it
    response.should have_tag('form')
  end

  describe "in the edit form" do
    it "renders the stories/form partial" do
      template.expect_render(:partial => "stories/form", :locals => { :form => anything, :story => @story }).and_return(%|<p id="stories_form" />|)
      render_it
      in_the_edit_form do
        response.should have_tag('p#stories_form')
      end
    end

    it "renders a submit button" do
      render_it
      in_the_edit_form do
        response.should have_tag('input[type=submit]')
      end
    end
  end

  #
  # HELPERS
  #
  def in_the_edit_form(&block)
    response.should have_tag('form[action=?]', story_path(@project, @story)), &block
  end
  
end





