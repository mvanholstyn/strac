require File.dirname(__FILE__) + '/test_helper'

class PresentationObjectSubclass < PresentationObject
  attr_accessor :foo_called, :ivar

  declare :foo do
    @foo_called = true
    :in_foo
  end
  
  # #to_sym == foo.to_sym
  delegate(:to_sym, 
           # delegate the foo_str method to foo().to_s
           :foo_str => :to_s, 
           :to => :foo)

  delegate(:baz,
           :barf => :bar,
           :to => :@ivar)

  declare :nil_method do
    nil
  end

  delegate(:nilthing, :to => :nil_method)
end

class PresentationObjectTest < Test::Unit::TestCase
  should "have declared values" do
    p = PresentationObject.new do |p|
      p.declare :foo, 1
    end

    p.declare :bar, 2
    
    assert_equal 1, p.foo
    assert_equal 2, p.bar
  end
  
  should "have declared values, initialized with a closure when accessed" do
    create_mocks :foo, :bar
    
    p = PresentationObject.new do |p|
      p.declare :foo, :foofoo do @foo.value end
      p.declare :bar do @bar.value end
    end
    
    @foo.expects(:value).returns(1)
    assert_equal 1, p.foo
    
    @foo.expects(:value).returns(1)
    assert_equal 1, p.foofoo

    @bar.expects(:value).returns(2)
    assert_equal 2, p.bar
    
    # Make sure block not evaluated more than once
    assert_equal 1, p.foo
    assert_equal 1, p.foofoo
    assert_equal 2, p.bar
  end
  
  should "allow values with questions marks to be declared" do
    create_mocks :foo
    p = PresentationObject.new do |p|
      p.declare :is_nice? do @foo.is_nice? end      
    end
    
    @foo.expects(:is_nice?).returns(true)
    assert_equal true, p.is_nice?
  end
  
  should "delegate methods to specified object" do
    create_mocks :foo
    p = PresentationObject.new do |p|
      p.delegate :bar, :far, :tar, :to => @foo
    end
    
    @foo.expects(:bar).returns('val1')
    assert_equal 'val1', p.bar
    
    @foo.expects(:far).returns('val2')
    assert_equal 'val2', p.far
    
    @foo.expects(:tar).returns('val3')
    assert_equal 'val3', p.tar    
  end

  should "delegate methods to specified objects with different method names" do
    create_mocks :obj
    p = PresentationObject.new do |p|
      p.delegate :x, :foo => :bar, :boo => :gah!, :to => @obj
    end
    
    @obj.expects(:x).returns("x")
    assert_equal "x", p.x
    
    @obj.expects(:bar).returns("bar")
    assert_equal "bar", p.foo
    
    @obj.expects(:gah!).returns("holy crap batman!")
    assert_equal "holy crap batman!", p.boo
  end
  
  should "raise exception if no :to specfied in delegate" do
    assert_raise(RuntimeError) { PresentationObject.new { |p| p.delegate :a, :b, :c} }
  end
  

  context ".declare" do
    setup do
      @target = PresentationObjectSubclass.new
    end
    
    should "be able to do class level declarations" do
      assert_equal :in_foo, @target.foo
      assert @target.foo_called

      @target.foo_called = false
      assert_equal :in_foo, @target.foo
      assert !@target.foo_called
    end
  end

  context ".delegate" do
    setup do
      @target = PresentationObjectSubclass.new
    end

    should "map to different names on methods" do
      assert_equal 'in_foo', @target.foo_str
      assert @target.foo_called
    end

    should "map to same names on methods" do
      assert_equal :in_foo, @target.to_sym
      assert @target.foo_called
    end

    should "return nil if the method delegated to returns nil" do
      assert_nil @target.nilthing
    end

    should "map to different names on instance variables" do
      @target.ivar = stub(:bar => 1001)
      assert_equal 1001, @target.barf
    end

    should "map to same names on instance variables" do
      @target.ivar = stub(:baz => 2001)
      assert_equal 2001, @target.baz
    end

    should "return nil if the instance variable delegated to is nil" do
      @target.ivar = nil
      assert_nil @target.baz
    end
  end
end
