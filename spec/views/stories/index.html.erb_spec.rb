require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories/index.html.erb" do
  include StoriesHelper

  def render_it
    assigns[:project] = @project
    assigns[:stories_presenter] = @stories_presenter
    render "/stories/index.html.erb"
  end
  
  before do
    @iterations = mock "iterations presenter"
    @tags = mock "tags presenter"
    @stories_presenter = stub("stories presenter", 
      :iterations? => false,
      :iterations => @iterations, 
      :tags? => false,
      :tags => @tags)
    @project = mock_model(Project)
    template.stub_render(:partial => "stories/search_form")
  end

  it "hides the draggable markers on the stories" do
    render_it
    response.should have_text(%|$$('#stories .draggable', '#stories .iteration .actions').invoke("hide")|.to_regexp)
  end
  
  it "renders the stories/search_form" do
    template.expect_render(
      :partial => "stories/search_form"
    ).and_return(%|<p id="search_form_partial" />|)
    render_it
    response.should have_tag('p#search_form_partial')
  end
  
  describe "when the the stories presenter is presenting on iterations" do
    before do
      @stories_presenter.stub!(:iterations?).and_return(true)
      template.expect_render(:partial => "stories/iterations", :locals => {:iterations=>@iterations}).and_return(%|<p id="iterations-partial" />|)
    end
    
    it "renders a link to the tag-based view of the stories" do
      render_it
      response.should have_tag('a[href=?].tags_view', stories_path(@project, :view => "tags"))
    end

    it "renders the stories/iterations partial" do
      render_it
      response.should have_tag("#iterations-partial")
    end

  end
  
  describe "when the the stories presenter is presenting on tags" do
    before do
      @stories_presenter.stub!(:iterations?).and_return(false)
      @stories_presenter.stub!(:tags?).and_return(true)
      template.expect_render(:partial => "stories/tags", :locals => {:tags=>@tags}).and_return(%|<p id="tags-partial" />|)
    end

    it "renders a link to the iteration-based view of the stories" do
      render_it
      response.should have_tag('a[href=?].iterations_view', stories_path(@project, :view => "iterations"))
    end
    
    it "renders the stories/tags partial" do
      render_it
      response.should have_tag("#tags-partial")
    end
  end

end

