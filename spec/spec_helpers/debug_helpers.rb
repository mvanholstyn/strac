class Spec::Rails::Example::ViewExampleGroup
  include ERB::Util
  
  def puts_body
    puts "<pre>" + h(response.body) + "</pre>"
  end
end