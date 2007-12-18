require File.join( File.dirname( __FILE__ ), "test_helper")

class ActsAsComparableTest < Test::Unit::TestCase
  
  def setup
    DummyModel.send :acts_as_comparable
  end
  
  def test_models_are_different_when_both_records_are_new
    model1 = DummyModel.new :name=>"dog"
    model2 = DummyModel.new :name=>"cat"
    
    assert model1.different?(model2), "models should have been different!"
    assert !model1.same?(model2), "models shouldn't have been the same!"
  end
  
  def test_models_are_different_when_one_records_is_new
    model1 = DummyModel.new :name=>"dog"
    model1.instance_variable_set "@new_record", false
    
    model2 = DummyModel.new :name=>"cat"
    
    assert model1.different?(model2), "models should have been different!"
    assert !model1.same?(model2), "models shouldn't have been the same!"
  end
  
  def test_models_are_different_when_neither_record_is_new
    model1 = DummyModel.new :name=>"dog"
    model1.instance_variable_set "@new_record", false
    
    model2 = DummyModel.new :name=>"cat"
    model2.instance_variable_set "@new_record", false

    assert model1.different?(model2), "models should have been different!"
    assert !model1.same?(model2), "models shouldn't have been the same!"
  end
  
  def test_models_are_not_different_when_both_records_are_new 
    model1 = DummyModel.new :name=>"cat"
    model2 = DummyModel.new :name=>"cat"
    
    assert model1.same?(model2), "models should have been the same!"
    assert !model1.different?(model2), "models shouldn't have been different!"
  end
  
  def test_models_are_not_different_when_one_record_is_new 
    model1 = DummyModel.new :name=>"cat"
    model1.instance_variable_set "@new_record", false    
    
    model2 = DummyModel.new :name=>"cat"
    
    assert model1.same?(model2), "models should have been the same!"
    assert !model1.different?(model2), "models shouldn't have been different!"
  end
  
  def test_models_are_not_different_when_neither_record_is_new 
    model1 = DummyModel.new :name=>"cat"
    model1.instance_variable_set "@new_record", false
    
    model2 = DummyModel.new :name=>"cat"
    model2.instance_variable_set "@new_record", false

    assert model1.same?(model2), "models should have been the same!"
    assert !model1.different?(model2), "models shouldn't have been different!"
  end
    
  def test_differences_with_new_records
    model1 = DummyModel.new :id=>nil, :name=>"dog", :value=>"Tiny"
    model2 = DummyModel.new :id=>nil, :name=>"cat", :value=>"Norm"
    model1.instance_variable_set "@new_record", false
    
    differences = model1.differences(model2)

    assert differences[:name] == [ "dog", "cat" ], "Name was expected to be different!"
    assert differences[:value] == [ "Tiny", "Norm" ], "Value was expected to be different!"
    assert_equal 2, differences.size, "Wrong number of differences!"
  end
  
  def test_differences_with_one_new_record
    model1 = DummyModel.new :id=>nil, :name=>"dog", :value=>"Tiny"
    model2 = DummyModel.new :id=>5, :name=>"cat", :value=>"Norm"
    model2.instance_variable_set "@new_record", false
    
    differences = model1.differences(model2)

    assert differences[:id] == [ nil, 5 ], "ID was expected to be different!"
    assert differences[:name] == [ "dog", "cat" ], "Name was expected to be different!"
    assert differences[:value] == [ "Tiny", "Norm" ], "Value was expected to be different!"
    assert_equal 3, differences.size, "Wrong number of differences!"
  end
  
  def test_differences_with_existing_records
    model1 = DummyModel.new :id=>1, :name=>"dog", :value=>"Tiny"
    model1.instance_variable_set "@new_record", false

    model2 = DummyModel.new :id=>5, :name=>"cat", :value=>"Norm"
    model1.instance_variable_set "@new_record", false

    differences = model1.differences(model2)

    assert differences[:id] == [ 1, 5 ], "ID was expected to be different!"
    assert differences[:name] == [ "dog", "cat" ], "Name was expected to be different!"
    assert differences[:value] == [ "Tiny", "Norm" ], "Value was expected to be different!"
    assert_equal 3, differences.size, "Wrong number of differences!"
  end
  
  def test_differences_when_using_only_option
    DummyModel.send :acts_as_comparable, :only=>[:name]
    
    model1 = DummyModel.new :id=>1, :name=>"dog", :value=>"Tiny"
    model1.instance_variable_set "@new_record", false

    model2 = DummyModel.new :id=>5, :name=>"cat", :value=>"Norm"
    model1.instance_variable_set "@new_record", false

    differences = model1.differences(model2)

    assert differences[:name] == [ "dog", "cat" ], "Name was expected to be different!"
    assert_equal 1, differences.size, "Wrong number of differences!"
  end
  
  def test_differences_when_using_except_option
    DummyModel.send :acts_as_comparable, :except=>[:id, :value]
    
    model1 = DummyModel.new :id=>1, :name=>"dog", :value=>"Tiny"
    model1.instance_variable_set "@new_record", false

    model2 = DummyModel.new :id=>5, :name=>"cat", :value=>"Norm"
    model1.instance_variable_set "@new_record", false

    differences = model1.differences(model2)

    assert differences[:name] == [ "dog", "cat" ], "Name was expected to be different!"
    assert_equal 1, differences.size, "Wrong number of differences!"
  end 
  
end