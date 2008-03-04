class RemoteSiteRenderer
  def initialize(options={})
    @page = options[:page]
  end
  
  def render_error(message)
    @page[:error].replace_html message
    @page[:notice].hide
    @page[:error].show
    @page.visual_effect :appear, :error    
  end
  
  def render_notice(message)
    @page[:notice].replace_html message
    @page[:error].hide
    @page[:notice].show
    @page.visual_effect :appear, :notice
    @page.delay(5) { @page.visual_effect :fade, :notice }
  end  
end