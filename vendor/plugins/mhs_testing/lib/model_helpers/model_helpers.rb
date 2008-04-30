class Spec::Rails::Example::RailsExampleGroup
  def mock_new_model(clazz, *args)
    model = mock_model(clazz, *args)
    model.stub!(:id)
    model.stub!(:to_param)
    model.stub!(:new_record?).and_return(true)
    model
  end
  
  def dummy_errors
    base_class = stub("base class", :human_attribute_name => "field")
    base = stub("base", :class => base_class)
    errors = ActiveRecord::Errors.new base
    errors.add "field"
    errors
  end
end