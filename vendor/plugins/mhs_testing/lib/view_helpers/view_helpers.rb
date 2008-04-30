class Spec::Rails::Example::ViewExampleGroup
  include ActionView::Helpers::RecordIdentificationHelper  

  def puts_body
    puts response.body
  end
  
  def render_it
    template = self.class.description.gsub(/^(\S+).*/, '\1')
    render template
  end
end