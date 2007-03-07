module StoriesHelper
  def toggle_hide_show_with_smart_loading id_to_show, *ids_to_hide
    update_page do |page| 
      page << "if( $('#{id_to_show}').visible() ) {"
			  page.visual_effect :blind_up, id_to_show, :duration => 0.3
			  page << "return false;"
			page << "} else if( $('#{id_to_show}').innerHTML != '' ) {"
			  ids_to_hide.each do |id_to_hide|
			    page.visual_effect :blind_up, id_to_hide, :duration => 0.3
			  end
			  page.visual_effect :blind_down, id_to_show, :duration => 0.3
			  page << "return false;"
			page << "}"
		end
  end
end
