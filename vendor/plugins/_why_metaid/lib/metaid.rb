class Object
  # The hidden singleton lurks behind everyone
  def metaclass; class << self; self; end; end
  alias_method :singleton_class, :metaclass
   
  def meta_eval(&blk)
    metaclass.instance_eval &blk
  end
  
  def meta_class_eval(code=nil, &blk)
    if code.nil?
      metaclass.class_eval &blk
    else
      metaclass.class_eval code, &blk
    end
  end

  # Adds methods to a metaclass
  def meta_def name, &blk
    meta_eval { define_method name, &blk }
  end

  # Defines an instance method within a class
  def class_def name, &blk
    class_eval { define_method name, &blk }
  end
end
