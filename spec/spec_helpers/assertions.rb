module Test::Unit::Assertions
  
  def assert_association( source, macro, name, klass=nil, options = {} )
    options = klass if options.empty? and klass.is_a?( Hash )
    if options[:polymorphic]
      options[:foreign_type] = "#{name}_type"
    end
    
    reflection = source.reflect_on_association( name )
    assert( reflection, 'association not defined' )
    assert_equal klass, reflection.klass, 'associated to wrong class'  unless options[:polymorphic]
    assert_equal macro, reflection.macro, 'wrong type of association'
    assert_equal options, reflection.options, 'incorrect association options'
  end

  def assert_attribute_has_error(object, attribute, error, message=nil)
    assert !object.valid?, "#{object.class.name} expecting #{attribute} to have error #{error.inspect} was valid"
    actual_errors = [object.errors.on(attribute) || []].flatten
    assert actual_errors.include?(error), "#{attribute} did not have the error #{error.inspect}. Actual errors: #{actual_errors.inspect}"
  end
    
  def assert_attribute_valid(object, attribute)
    object.valid?
    assert !object.errors.on(attribute), "#{attribute} has errors"
  end
  
  def assert_attribute_invalid(object, attribute)
    assert !object.valid?, "expected object to be invalid"
    assert_not_nil object.errors.on(attribute), "#{attribute} did not have any errors"
  end
  
  def assert_validates_presence_of(object, attribute, message="can't be blank")
    assert_attribute_has_error( object, attribute, message)
  end
    
  def assert_validates_numericality_of(object, attribute, message="is not a number")
    assert_attribute_has_error object, attribute, message
  end
  
  def assert_validates_uniqueness_of(object, attribute, message="has already been taken")
    assert !object.new_record?, "Object should be an existing record"
    new_object = object.class.new object.attributes
    assert_attribute_has_error new_object, attribute, message
  end
  
  def assert_validates_confirmation_of(object, attribute, msg="doesn't match confirmation")
    assert_attribute_has_error(object, attribute, msg)
  end
  
  def assert_validates_inclusion_of(object, attribute, msg="is not included in the list")
    assert_attribute_has_error(object, attribute, msg)
  end

end