class Multiblock
  def self.[](*args)
    new *args
  end
  
  def initialize(*args)
    _expect *args unless args.empty?
  end
  
  def [](*args)
    _expect *args
    self
  end
  
  def method_missing(name, *rest)
    if !@matched
      @matched = [@waiting_for, :else].include? name
      if @waiting_for == name
        @result = yield *@args
      elsif :else == name
        @result = yield @waiting_for, *@args
      end
    end
    
    @result
  end
  
  def matched?
    @matched
  end
  
  private
  
  def _expect(waiting_for, *args)
    @waiting_for = waiting_for.to_sym
    @args = args
    @result = nil
    @matched = false
  end
end