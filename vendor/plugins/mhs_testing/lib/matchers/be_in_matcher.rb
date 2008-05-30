module Spec::Matchers
  class BeIn
    def initialize(collection)
      @collection = collection
    end
    
    def matches?(item)
      @item = item
      @collection.include?(item)
    end
    
    def failure_message
      "#{@item} was expected to be in #{@collection.inspect}, but it wasn't."
    end

    def negative_failure_message
      "#{@item} was expected to NOT be in #{@collection.inspect}, but it was."
    end
  end
  
  def be_in(collection)
    BeIn.new(collection)
  end
end