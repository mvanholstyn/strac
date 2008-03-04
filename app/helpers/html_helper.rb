module HtmlHelper
  # TODO: Submit this as a patch to Rails
  def field_set_tag(legend = nil, options = {}, &block)
    content = capture(&block)
    concat(tag(:fieldset, options, true), block.binding)
    concat(content_tag(:legend, legend), block.binding) unless legend.blank?
    concat(content, block.binding)
    concat("</fieldset>", block.binding)
  end
end