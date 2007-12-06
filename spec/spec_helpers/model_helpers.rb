class Spec::Rails::Example::RailsExampleGroup
  def mock_new_model(clazz)
    model = mock_model(clazz)
    model.stub!(:id)
    model.stub!(:to_param)
    model.stub!(:new_record?).and_return(true)
    model
  end
end