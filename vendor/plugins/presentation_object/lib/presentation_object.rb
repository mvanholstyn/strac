require File.dirname(__FILE__) + "/cached_methods"

class PresentationObject
  include CachedMethods
  include ERB::Util
  
  class <<self
    alias_method :declare, :declare_cached
    alias_method :delegate, :delegate_cached
  end
  
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
        meta_def attr_name do ||
          results = block.call
          meta_def attr_name do
            results
          end
          results
        end
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
    
  alias_method :original_class, :class unless instance_methods.include?("original_class")
  def delegate(*names)
    hash = self.original_class.send :prepare_delegate_hash, names
    target = hash.delete :to

    hash.each_pair do |label, value|
      declare(label) { target.send value }
    end
  end
end
