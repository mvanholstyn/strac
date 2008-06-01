module RailsSeleniumStory::Helpers::EscapeString
  def escape_string string, num=1
    slashes = '\\\\' * num
    string.gsub(/('|")/, slashes + '\1')
  end
  
  def escape_regex string_or_regex
    if string_or_regex.is_a?(Regexp) && string_or_regex.inspect =~ /\/(.*)\//
      string_or_regex = $1
    end
    
    if string_or_regex.blank?
      ".*"
    else
      string_or_regex.gsub(/([\$'"\?\(\)\[\]\{\}\+\\\\])/, '\\\\\1')
    end
  end
end