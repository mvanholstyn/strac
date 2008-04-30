module RailsSeleniumStory::Helpers
  def click_link(path_or_options, options={})
    if path_or_options.is_a?(String)
      if path_or_options.starts_with?(".")
        path_or_options = { :class => path_or_options[1..-1] }
      elsif path_or_options.starts_with?("#")
        path_or_options = { :id => path_or_options[1..-1] }
      else
        path_or_options = { :href => path_or_options }
      end
    end

    begin
      see_link_with_href path_or_options
      scoped :click, descendant('a', path_or_options)
    rescue => ex
      if path_or_options[:href]
        see_link_containing_text path_or_options[:href] 
        scoped :click, link_containing_text(path_or_options[:href])
      else
        raise ex
      end
    end
    
    follow_all_redirects unless options[:makes_request] == false
  end
end