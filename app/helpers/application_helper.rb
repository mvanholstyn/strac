module ApplicationHelper
  def in_place_editor(field_id, options = {})
    function =  "new Ajax.InPlaceEditor("
    function << "'#{field_id}', "
    function << "'#{url_for(options.delete(:url))}'"
  
    #Backwards compatibility
    options[:ok_text] = options.delete(:save_text) if options[:save_text]
    options[:ajax_options] = options.delete(:options) if options[:options]
    options[:html_response] = options[:html_response]

    js_options = {}
    js_options['loadTextURL'] = "'#{url_for(options.delete(:load_text_url))}'" if options[:load_text_url]

    js_options['callback'] = "function(form, value) { return '#{options[:param_name]}=' + encodeURIComponent(value) + '&"
    js_options['callback'] << "#{request_forgery_protection_token}=' + encodeURIComponent('#{escape_javascript form_authenticity_token}')}"
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
  
  class Conversion
    attr_reader :keyword, :model, :link
    
    class << self
      def conversions
        @conversions ||= {
          :S => new( :S, Story, [ :story, :project_id, :id ] ),
          :B => new( :B, Bucket ),
          :I => new( :I, Iteration, [ :iteration, :project_id, :id ] ),
          :USER => new( :USER, User ),
          :P => new( :P, Project, [ :project, :id ] ),
          :STATUS =>new( :STATUS, Status ),
          :PRIORITY => new( :PRIORITY, Priority ) }
      end
    end    
    
    def initialize( keyword, model, link = nil )
      @keyword, @model, @link = keyword, model, link
    end
  end
  
  
  # TODO - come up with a great way to test this or extract it out in a couple objects or methods and test those
  def expand_ids( data )
    data.gsub( /(^|\W)((#{Conversion.conversions.map{ |k,c| k.to_s }.join( '|' )})(\d+))(\W|$)/ ) do |match|
      conversion = Conversion.conversions[$3.to_sym]
      object = conversion.model.find_by_id( $4 )
      if object
        if conversion.link
          method = conversion.link.first
          options = {}
          conversion.link[1...conversion.link.size].each { |p| options[p] = object.send( p ) }
          url = send( "#{method}_path".to_sym, options )
          $1 + link_to( object.name, url ) + $5
        else
          link = $1 + object.name + $5
        end
      else
        match
      end
    end
  end
end
