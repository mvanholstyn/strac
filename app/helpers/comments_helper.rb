module CommentsHelper
  
  def close_comments_link
    link_to( "Close Comments", "#", 
      :onclick => update_page { |page| 
        page.visual_effect( :blind_up, "story_#{@story.id}_comments", :duration => 0.3 ); page << "return false;" } )    
  end
  
  def comments_popup_link
    link_to "Popup Comments (#{@story.comments.size})", 
    	comments_url( :project_id=>@story.project_id, :story_id=>@story.id ), 
    	:popup => ['new_window', 'height=600,width=500,resizable=1,scrollbars=1,statusbar=1']
  end
  
  def comments_inline_link
    link_to_remote "Inline Comments (#{@story.comments.size})", 	
        :url=>comments_url( :project_id=>@story.project_id, :story_id=>@story.id, :inline=>true ),
        :method => :get
  end  
  
  def is_rendering_inline
    @is_rendering_inline
  end
  
  def is_rendering_popup
    ! @is_rendering_inline
  end
    
end
