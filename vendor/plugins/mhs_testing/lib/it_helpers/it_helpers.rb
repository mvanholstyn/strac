require 'spec/rails'

module Spec::Example::ExampleGroupMethods
  def it_delegates(*args)
    options = args.extract_options!
    methods = args
    src = options[:on]
    to = options[:to]
    raise "Missing an object to call the method on, pass in :on" unless src
    raise "Missing an object to ensure the method delegated to, pass in :to" unless to

    method_options = options.reject{|k,v| [:on, :to].include?(k)}
    methods.each {|m| method_options[m] = m}
    method_options.each do |source_method, to_method|
      it "delegates ##{source_method} to @#{to}.#{to_method}" do
        obj = instance_variable_get "@#{to}"
        _src = instance_variable_get "@#{src}"
        return_val = stub("return val")
        obj.should_receive(to_method).and_return(return_val)
        _src.send!(source_method).should == return_val
      end
    end
  end
  
  def it_provides_liquid_methods(*methods)
    it "defines ##{self.described_type}::LiquidDrop (declare liquid_methods to do this automatically)" do
      self.class.described_type.const_defined?(:LiquidDrop).should be_true
    end
    
    if self.described_type.const_defined?(:LiquidDrop)
      klass = self.described_type::LiquidDrop
      describe klass do
        before do
          @presenter = stub("presenter")
          @drop = klass.new(@presenter)
        end
        methods.each do |method|
          it "provides ##{method} to liquid" do
            return_value = stub("return value")
            @presenter.should_receive(method).and_return(return_value)
            @drop.send(method).should == return_value
          end
        end
      end
    end
  end

  def it_has_accessors(attribute, options)
    on_variable_name = options[:on]
    raise "Missing an object to call the method on, pass in :on" unless on_variable_name

    it "has accessors for ##{attribute}" do
      on = instance_variable_get "@#{on_variable_name}"
      on.send("#{attribute}=", :the_value)
      on.send(attribute).should == :the_value
    end
    
    if options.keys.include?(:default)
      it "defaults ##{attribute} to #{options[:default].inspect}" do
        on = instance_variable_get "@#{on_variable_name}"
        on.send(attribute).should == options[:default]
      end
    end
  end
  alias_method :it_has_accessor, :it_has_accessors
  
end

module Spec::Example::ExampleGroupMethods
  def model_class
    self.described_type
  end

  def it_requires *attributes
    attributes.each do |attribute|
      it "requires #{attribute}" do
         model = self.class.model_class.new
         assert_validates_presence_of model, attribute
      end
    end
  end

  def it_protects attribute
    it "protects #{attribute} from mass assignment" do
      default_value = self.class.model_class.new[attribute]
      model = self.class.model_class.new(attribute => !default_value)
      model[attribute].should == default_value
    end
  end

  def it_validates_uniqueness_of attribute, options
    it "validates the uniqueness of #{attribute}" do
      model = self.class.model_class.new
      if options[:values]
        options[:values].each_pair do |attribute, value|
          model[attribute] = value
        end
      else
        model[attribute] = options[:value]
      end
      assert_attribute_invalid model, attribute
    end

    if options[:allow_nil]
      it "doesn't enforce uniqueness on #{attribute} when it is nil" do
        assert self.class.model_class.count(:conditions => {attribute => nil}) > 0, "must have a record where #{attribute} is nil to check this validation"
        model = self.class.model_class.new
        model[attribute] = nil
        assert_attribute_valid model, attribute
      end
    else
      it "enforces uniqueness on #{attribute} when it is nil" do
        model = self.class.model_class.new
        model[attribute] = nil
        assert_attribute_invalid model, attribute
      end
    end
  end

  def it_validates_inclusion_of attribute, options
    options[:exclusions].each do |exclusion|
      it "does not allow #{attribute} to have a value of #{exclusion.inspect}" do
        model = self.class.model_class.new
        model[attribute] = exclusion
        assert_attribute_invalid(model, attribute)
      end
    end
    options[:inclusions].each do |inclusion|
      it "allows #{attribute} to have a value of #{inclusion.inspect}" do
        model = self.class.model_class.new
        model[attribute] = inclusion
        assert_attribute_valid(model, attribute)
      end
    end
  end

  def it_has_one association, options={}
    it "has one #{association}" do
      self.class.model_class.should have_association2(:has_one, association.to_sym, options)
    end
  end


  def it_has_many association, options={}
    it "has many #{association}" do
      self.class.model_class.should have_association2(:has_many, association.to_sym, options)
    end
  end

  def it_belongs_to association, options={}
    a_or_an = association.to_s =~ /^[aeiou]/i ? "an" : "a"
    it "belongs to #{a_or_an} #{association}" do
      self.class.model_class.should have_association2(:belongs_to, association.to_sym, options)
    end
  end

end
