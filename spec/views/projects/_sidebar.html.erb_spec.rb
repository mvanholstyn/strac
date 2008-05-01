require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/_sidebar.html.erb" do
  def render_it
    render :partial => "projects/sidebar", :locals => { :project => @project, :user => @user }
  end

  before do
    @project = mock_new_model(Project)
    @user = mock_model(User)
    template.stub_render(:partial => "projects/summary", :locals => anything)
    template.stub_render(:partial => "projects/people_sidebar", :locals => anything)
    template.stub_render(:partial => "projects/user_sidebar", :locals => anything)
  end
  
  describe "when the project is not a new record" do
    before do
      @project.stub!(:id).and_return(1)
      @project.stub!(:name).and_return("Baz")
    end
    
    it "displays the project's name" do
      render_it
      response.should have_text("Baz".to_regexp)
    end
    
    it "renders the projects/summary partial" do
      template.expect_render(
        :partial => "projects/summary",
        :locals => { :project => @project }
      ).and_return(%|<p id="summary-partial" />|)
      render_it
      response.should have_tag('p#summary-partial')
    end
    
    it "renders the projects/people_sidebar partial" do
      template.expect_render(
        :partial => "projects/people_sidebar",
        :locals => { :project => @project }
      ).and_return(%|<p id="people-partial" />|)
      render_it
      response.should have_tag('p#people-partial')
    end
  end
  
  it "renders the projects/user_sidebar partial" do
    template.expect_render(
      :partial => "projects/user_sidebar",
      :locals => { :project => @project }
    ).and_return(%|<p id="user-partial" />|)
    render_it
    response.should have_tag('p#user-partial')    
  end
end

__END__
<div id="sidebar">
  <% if project and project.id -%>
    <h2><%= project.name %>: summary</h2>
    <%= render :partial => "projects/summary", :locals => { :project => project } %>
    
    <h2><%= project.name %>: people</h2>
    <%= render :partial => "projects/people_sidebar", :locals => { :project => project } %>
  <% end -%>
  
  <h2 style="display: inline;" class="your_projects">your projects</h2>
  <%= render :partial => "projects/user_sidebar", :locals => { :project => project } %>
</div>


