module ActionController::Assertions::SelectorAssertions 
  def response_from_page_or_rjs_with_rjs_helpers
    doc = response_from_page_or_rjs_without_rjs_helpers
    if doc.to_s.blank?
      response.body =~ /\$\("[^"]+"\).update\((.*)\)/
      doc = @html_document = HTML::Document.new(unescape_rjs($1)).root
    end
    doc
  end
  alias_method_chain :response_from_page_or_rjs, :rjs_helpers
end