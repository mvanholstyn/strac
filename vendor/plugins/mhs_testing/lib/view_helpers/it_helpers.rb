class Spec::Rails::Example::ViewExampleGroup
  def self.it_renders_a_link_to_unless_current(named_route)
    describe "when #{named_route} is the current page" do
      it "does not render a link to the #{named_route} page" do
        render_it
        response.should have_tag("a[href=?]", send(named_route))
      end
    end
    
    describe "when #{named_route} is not the current page" do
      it "renders a link to the #{named_route}" do
        template.stub!(:current_page?).and_return(true)
        render_it
        response.should_not have_tag("a[href=?]", send(named_route))
      end
    end
  end

  def self.it_renders_javascript_tags_for(*jsfiles)
    if jsfiles.include?(:defaults)
      jsfiles.delete(:defaults)
      jsfiles += [:prototype, :effects, :dragdrop, :controls]
    end
    jsfiles.each do |jsfile|
      it "renders a javascript tag for #{jsfile}.js" do
        render_it
        response.should have_tag('script[src*=?][type=text/javascript]', "#{jsfile}.js")
      end
    end
  end
  
  def self.it_renders_stylesheet_link_tags_for(*cssfiles)
    options = cssfiles.extract_options!
    media = options[:media] || "screen"
    cssfiles.each do |cssfile|
      it "renders a link tag for #{cssfile}.css" do
        render_it
        response.should have_tag('link[href*=?][media=?][rel=stylesheet][type=text/css]', "#{cssfile}.css", media)
      end
    end
  end
  
  def self.it_does_not_render_stylesheet_link_tags_for(*cssfiles)
    cssfiles.each do |cssfile|
      it "does not render a link tag for #{cssfile}.css" do
        render_it
        response.should_not have_tag('link[href*=?][rel=stylesheet][type=text/css]', "#{cssfile}.css")
      end
    end
  end
  
  # This is for use when you are using the built-in: error_messages_for :some_object 
  def self.it_renders_error_messages_for(*models)
    models.each do |model|
      it "renders error messages for #{model}" do
        instance = instance_variable_get "@#{model}"
        errors = stub("Errors", :count => 1, :full_messages => ["attribute1 error1"])
        instance.stub!(:errors).and_return(errors)
        render_it
        response.should have_tag("#errorExplanation", "attribute1 error1".to_regexp)
      end
    end
  end
  
  # This is for use when you have an error messages container built from a dom id.
  # IE: <p d=<%= dom_id(trip, 'error_messages') %></p>
  def self.it_renders_an_error_messages_container_for(*models)
    models.each do |model|
      it "renders an error messages container for #{model}" do
        ivar = "@#{model}"
        instance = instance_variable_get ivar
        raise "No #{ivar} instance variable." unless instance
        render_it
        response.should have_tag("##{dom_id(instance, 'error_messages')}")
      end
    end
  end
end
