module HaveAssociationMatcher  
  class HaveAssociation  
    attr_accessor :macro, :name, :klass, :options, :target, :reflection
    
    def initialize(macro, name, klass, options)  
      @macro = macro
      @name = name
      @klass = klass
      @options = options
    end  
  
    def matches?(target)
      @target = target
      self.options = klass if options.empty? and klass.is_a?( Hash )
      @reflection = target.reflect_on_association( name )
      
      if options[:polymorphic] 
        options[:foreign_type] = "#{name}_type"
      elsif !options[:foreign_key]
        options[:foreign_key] = name.to_s.underscore + "_id"        
      end
      options[:class_name] = klass.name unless klass.is_a?(Hash) || options[:class_name] # default class name    
      
      return false if !options[:polymorphic] && klass != reflection.klass
      return false if macro != reflection.macro
      return false if options != reflection.options
      true
    end  
  
    def failure_message  
      "expected #{target} association: #{macro} with options #{options.inspect} but was " +  
      "#{reflection.macro} with options #{reflection.options.inspect}>"  
    end  
    alias_method :negative_failure_message, :failure_message
  end  
  
  # Actual matcher that is exposed.  
  def have_association(macro, name, klass=nil, options = {})  
    HaveAssociation.new(macro, name, klass, options)  
  end  
end  