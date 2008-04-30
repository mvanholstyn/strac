module Spec::Matchers
  class HaveAssociation2
    attr_accessor :macro, :name, :klass, :options, :target, :reflection

    def initialize(macro, name, options)
      @macro = macro
      @name = name
      @options = options
    end

    def matches?(target)
      @target = target
      @reflection = @target.reflect_on_association( name )
      return false unless @reflection

      if options[:polymorphic]
        options[:foreign_type] = "#{name}_type"
        # don't check polymorphic associations for a source class
      elsif !options[:through]
        klass_name = self.options[:class_name] || nil
        @klass = klass_name ? klass_name.constantize : @reflection.klass
        self.options = klass if options.empty? and klass.is_a?( Hash )
      end

      # if the developer isn't expecting association extensions, and the reflection has none, then remove it
      # see Rails doc on has_many and association extensions for reference
      reflection_options = reflection.options.dup
      if !options.has_key?(:extend) && reflection.options.has_key?(:extend) && reflection.options[:extend].blank?
        reflection_options.delete(:extend)
      end
      
      if options[:through] && !target.reflections[options[:through]]
        @missing_through = true
        return false
      elsif !options[:through] && !options[:polymorphic] && klass != reflection.klass
        return false
      elsif macro != reflection.macro
        return false
      elsif options != reflection_options
        return false
      end
      true
    end

    def failure_message
      if reflection
        msg = "expected #{target} association: #{macro} with options #{options.inspect} but was " +
          "#{reflection.macro} with options #{reflection.options.inspect}>"
        msg += ", the :through association does not exist!" if @missing_through
      else
        msg = "expected #{target} association: #{macro} with options #{options.inspect} but found none"
      end
      msg
    end
    alias_method :negative_failure_message, :failure_message
  end

  # Actual matcher that is exposed.
  def have_association2(macro, name, options = {})
    HaveAssociation2.new(macro, name, options)
  end
end
