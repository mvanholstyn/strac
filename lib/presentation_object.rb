class PresentationObject
  include ActionView::Helpers::TagHelper # link_to
  include ActionView::Helpers::UrlHelper # url_for
  include ActionView::Helpers::NumberHelper # url_for
  include ActionController::UrlWriter # named routes
    
  def initialize()
    yield self if block_given?
  end
  
  def declare(*attr_names, &block)
    if block
      args = []
      attr_names.each do |attr_name|
        meta_class_eval <<-RUBY
          def #{attr_name}
            results = @#{attr_name.to_s.gsub('?','_qmark')}_block.call
            meta_class_eval do
              define_method :#{attr_name}, lambda { results }
            end
            results
          end
        RUBY

        instance_variable_set "@#{attr_name.to_s.gsub('?','_qmark')}_block", block
      end
    else
      value = attr_names.pop
      attr_names.each do |attr_name|
        meta_def attr_name do
          value
        end
      end
    end
  end
    
  def delegate(*names)
    hash = names.last.is_a?(Hash) ? names.pop : {}
    raise "need a :to parameter" unless hash[:to]

    target = hash.delete :to
    names.each do |name| 
      hash[name] = name
    end

    hash.each_pair do |label, value|
      declare(label) { target.send value }
    end
  end
  
end
