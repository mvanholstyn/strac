module StoriesHelper
  
  # def toggle_hide_show_with_smart_loading id_to_show, *ids_to_hide
  #   update_page do |page| 
  #     page << "if( $('#{id_to_show}').visible() ) {"
  #         page.visual_effect :blind_up, id_to_show, :duration => 0.3
  #         page << "return false;"
  #       page << "} else if( $('#{id_to_show}').innerHTML != '' ) {"
  #         ids_to_hide.each do |id_to_hide|
  #           page.visual_effect :blind_up, id_to_hide, :duration => 0.3
  #         end
  #         page.visual_effect :blind_down, id_to_show, :duration => 0.3
  #         page << "return false;"
  #       page << "}"
  #     end
  # end
  
  def options_for_responsible_parties selected = nil
    html = ""
    html << content_tag( "option", "Anyone", :value => "" )
    attributes = { :value => "user_#{current_user.id}" }
    attributes[:selected] = "selected" if attributes[:value] == selected
    html << content_tag( "option", "Me (#{current_user.full_name})", attributes )
    html << content_tag( "option", "", :value => "" )
    Company.find( :all ).each do |c|
    attributes = { :value => "company_#{c.id}", :class => 'group' }
    attributes[:selected] = "selected" if attributes[:value] == selected
      html << content_tag( "option", c.name, attributes )
      c.users.each do |u|
        attributes = { :value => "user_#{u.id}", :class => 'option' }
        attributes[:selected] = "selected" if attributes[:value] == selected and attributes[:value] != "user_#{current_user.id}"
        html << content_tag( "option", u.full_name, attributes )
      end
    end
    html
  end
  
end
