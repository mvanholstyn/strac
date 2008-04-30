module AssociationMatchers
  class HaveAssociation  #:nodoc:

    def initialize(type, name, options = {})
      @type = type
      @name = name
      @options = options
      @class_name = options[:class_name] || @name.to_s.singularize.camelize
    end

    def matches?(model)
      @model = model
      @association = model.class.reflect_on_association(@name)

      @association && @association.macro == @type &&
        @association.class_name == @class_name #&&
        # @association.options.only(*@options.keys) == @options
    end

    def failure_message
      "expected #{model.inspect} to have a #{type} association called #{name}"
    end

    def description
      "have a #{type} association called :#{name}"
    end

  private
    attr_reader :type, :name, :model, :association
  end
  
  def have_one(name, options = {})
    HaveAssociation.new(:has_one, name, options)
  end

  def have_many(name, options = {})
    HaveAssociation.new(:has_many, name, options)
  end
  
  def belong_to(name, options = {})
    HaveAssociation.new(:belongs_to, name, options)
  end
  
  def have_and_belong_to_many(name, options = {})
    HaveAssociation.new(:has_and_belongs_to_many, name, options)
  end
end