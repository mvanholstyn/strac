module RailsSeleniumStory::Helpers
  def eval_js(code)
    get_eval <<-JS
      selenium.browserbot.getCurrentWindow().eval("#{
        code.gsub('"', '\\"').gsub("\n"," ")
      }")
    JS
  end

  def get_json(code, objects={})
    entries = objects.entries
    ActiveSupport::JSON.decode(
      eval_js("
        Object.toJSON(
          (function(#{entries.map(&:first).join(', ')}){
            return #{code};
          })(#{entries.map(&:last).join(', ')})
        )
      ")
    )
  end
end
