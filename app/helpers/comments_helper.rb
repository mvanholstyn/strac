module CommentsHelper
  attr_accessor :should_render_comment_links
  
  def should_render_comment_links
    @should_render_comment_links ||= true
  end
  
  def comment_datetime_for datetime
    datetime.strftime "%b. %d, %Y at %I:%M:%S%p"
  end
end
