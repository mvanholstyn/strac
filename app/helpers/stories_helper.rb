module StoriesHelper
  def options_for_responsible_parties project, selected = nil
    html = ""
    html << content_tag( "option", "Anyone", :value => "" )
    attributes = { :value => "user_#{current_user.id}" }
    attributes[:selected] = "selected" if attributes[:value] == selected
    html << content_tag( "option", "Me (#{current_user.full_name})", attributes )
    project.users.find(:all, :conditions => ["users.id != ?", current_user.id]).each do |u|
      attributes = { :value => "user_#{u.id}", :class => 'option' }
      attributes[:selected] = "selected" if attributes[:value] == selected and attributes[:value] != "user_#{current_user.id}"
      html << content_tag( "option", u.full_name, attributes )
    end
    html
  end  
end
