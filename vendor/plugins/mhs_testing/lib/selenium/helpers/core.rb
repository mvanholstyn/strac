module RailsSeleniumStory::Helpers

  def do_click(locator)
    browser.do_command("click", [locator,])
  end

  def follow_all_redirects
    wait_until_page_loads
  end

  def html_document
    HTML::Document.new(browser.get_html_source)
  end
  
  def window
    "this.browserbot.getCurrentWindow()"
  end

  def response_from_page_or_rjs
    html_document.root
  end

  def descendant(tag, attrs=nil)
    if tag.is_a? Hash
      attrs = tag
      tag = '*'
    end

    selector = "//#{tag}"
    if attrs
      selector += '['
      attr_list = []
      attrs.each_pair do |key, value|
        if key.is_a? Symbol
          attr_list << "@#{key}='" + value.gsub(/'/){|m| "\\#{m}"} + "'"
        else
          attr_list << "#{key}='" + value.gsub(/'/){|m| "\\#{m}"} + "'"
        end
      end
      selector += attr_list.join(', ')
      selector += "]"
    end
    selector
  end

  def js_regex_escape regexp_or_string
    case regexp_or_string
    when Regexp
      regexp_or_string.source
    when String
      Regexp.escape(regexp_or_string)
    else
      raise "Don't know how to escape #{regexp_or_string.inspect}. Try a string or regexp instead."
    end
  end
  
  
  # Use bling to select an element in a wait_for_condition or other call that executes code
  # For example
  #   wait_for_condition %{/foo/.test(#{bling '//a.special'}.innerText)}, 1000
  def bling(selector)
    "selenium.browserbot.findElement('#{escape_string(selector)}')"
  end
  
  def escape_string string
    string.gsub(/('|")/, '\\\\\1')
  end
  
  def wait_for_content_to_match(regexp_or_string, options={})
    options = options.reverse_merge(
      :element => "//body",
      :content_type => 'innerHTML',
      :timeout => 30000
    )
    pattern = js_regex_escape(regexp_or_string)
    wait_for_condition %{/#{pattern}/.test(#{bling options[:element]}.#{options[:content_type]})}, options[:timeout]
  end
  
  def wait_for_content_to_not_match(regexp_or_string, options={})
    options = options.reverse_merge(
      :element => "//body",
      :content_type => 'innerHTML',
      :timeout => 30000
    )
    pattern = js_regex_escape regexp_or_string
    wait_for_condition %{!/#{pattern}/.test(#{bling options[:element]}.#{options[:content_type]})}, options[:timeout]
  end

  def scopes
    @scopes ||= []
  end
  
  def in_scope selector, &block
    if selector =~ /^#(.*)$/
      selector = descendant(:id => $1)
    end

    scopes << selector
    begin
      yield
    ensure
      scopes.pop
    end
  end
  
  def scope_selector
    scopes.join
  end
  
  def scoped_type text, options={}
    if options[:in]
      in_scope options[:in] do
        type scope_selector, text
      end
    else
      type scope_selector, text
    end
  end
  
  def is_scoped_element_present selector
    in_scope selector do
      is_element_present scope_selector
    end
  end
  
  def scoped(method, selector, *args)
    value = nil
    in_scope selector do
      value = send(method, scope_selector, *args)
    end
    value
  end

  def wait_until(max_wait = 30)
    start = Time.now
    until Time.now - start > max_wait
      value = yield
      return value if value
      sleep 0.25
    end
    false
  end  

  def wait_until_page_loads
    wait_for_page_to_load 10000
  end

end
