module ApplicationHelper
  def in_place_editor(field_id, options = {})
    function =  "new Ajax.InPlaceEditor("
    function << "'#{field_id}', "
    function << "'#{url_for(options.delete(:url))}'"

    #Backwards compatibility
    options[:ok_text] = options.delete(:save_text) if options[:save_text]
    options[:ajax_options] = options.delete(:options) if options[:options]
    options[:eval_scripts] = options.delete(:script) if options[:script]

    js_options = {}
    js_options['loadTextURL'] = "'#{url_for(options.delete(:load_text_url))}'" if options[:load_text_url]
    js_options['callback'] = "function(form) { return #{options.delete(:with)} }" if options[:with]
    js_options['ajaxOptions'] = options_for_ajax( options.delete(:ajax_options) ) if options[:ajax_options]

    options.each_pair do |k,v|
      js_options[k.to_s.camelize( :lower )] = case v
        when Fixnum, TrueClass, FalseClass: v
        else "'#{v}'"
      end
    end

    function << (', ' + options_for_javascript(js_options)) unless js_options.empty?
    function << ')'

    javascript_tag(function)
  end
  
  def convert_story_ids_to_links( description )
    description.gsub( /(^|\W)(S(\d+))(\W|$)/ ) do |story_id|
      story = Story.find_by_id( $3 )
      if story
        url = story_path( :project_id=>story.project_id, :id=>story.id )
        link = $1 + link_to( $2, url, :title=>story.summary ) + $4
        link
      else
        story_id
      end
    end
    
  end

end
