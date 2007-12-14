describe "/stories/_iterations.html.erb" do

  def render_it
    render :partial => "stories/tags", :locals => { :tags => @tags }
  end

end