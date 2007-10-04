require File.dirname(__FILE__) + '/../../spec_helper'

module Spec
  module DSL
    class FakeReporter < Spec::Runner::Reporter
      attr_reader :added_behaviour
      def add_behaviour(description)
        @added_behaviour = description
      end
    end

    describe Example, :shared => true do
      before :all do
        @original_rspec_options = $rspec_options
      end

      before :each do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        $rspec_options = @options
        @options.formatters << mock("formatter", :null_object => true)
        @options.backtrace_tweaker = mock("backtrace_tweaker", :null_object => true)
        @reporter = FakeReporter.new(@options)
        @options.reporter = @reporter
        @behaviour = Class.new(Example).describe("example") do
          it "does nothing"
        end
        class << @behaviour
          public :include
        end
        @result = nil
      end

      after :each do
        $rspec_options = @original_rspec_options
        Example.clear_before_and_after!
      end
    end
    
    describe Example, ".it" do
      it_should_behave_like "Spec::DSL::Example"

      it "should should create an example instance" do
        lambda {
          @behaviour.it("")
        }.should change(@behaviour.example_definitions, :length).by(1)
      end
    end

    describe Example, ".xit" do
      it_should_behave_like "Spec::DSL::Example"
      
      before(:each) do
        Kernel.stub!(:warn)
      end
      
      it "should NOT  should create an example instance" do
        lambda {
          @behaviour.xit("")
        }.should_not change(@behaviour.example_definitions, :length)
      end
      
      it "should warn that it is disabled" do
        Kernel.should_receive(:warn).with("Example disabled: foo")
        @behaviour.xit("foo")
      end
    end

    describe "Example", ".suite" do
      it_should_behave_like "Spec::DSL::Example"

      it "should return an empty ExampleSuite when there is no description" do
        Example.description.should be_nil
        Example.suite.should be_instance_of(ExampleSuite)
        Example.suite.tests.should be_empty
      end

      it "should return an ExampleSuite with Examples" do
        behaviour = Class.new(Example).describe('example') do
          it "should pass" do
            1.should == 1
          end
        end
        suite = behaviour.suite
        suite.tests.length.should == 1
        suite.tests.first.rspec_definition.description.should == "should pass"
      end

      it "should include methods that begin with test and has an arity of 0 in suite" do
        behaviour = Class.new(Example).describe('example') do
          def testCamelCase
            true.should be_true
          end
          def test_any_args(*args)
            true.should be_true
          end
          def test_something
            1.should == 1
          end
          def test
            raise "This is not a real test"
          end
        end
        suite = behaviour.suite
        suite.tests.length.should == 3
        descriptions = suite.tests.collect {|test| test.rspec_definition.description}.sort
        descriptions.should == ["testCamelCase", "test_any_args", "test_something"]
      end

      it "should not include methods that begin with test_ and has an arity > 0 in suite" do
        behaviour = Class.new(Example).describe('example') do
          def test_invalid(foo)
            1.should == 1
          end
          def testInvalidCamelCase(foo)
            1.should == 1
          end
        end
        suite = behaviour.suite
        suite.tests.length.should == 0
      end
    end

    describe "Example", ".description" do
      it_should_behave_like "Spec::DSL::Example"

      it "should return the same description instance for each call" do
        @behaviour.description.should eql(@behaviour.description)
      end
    end

    describe "Example", ".run" do
      it_should_behave_like "Spec::DSL::Example"
    end

    describe "Example", ".remove_after" do
      it_should_behave_like "Spec::DSL::Example"

      it "should unregister a given after(:each) block" do
        after_all_ran = false
        @behaviour.it("example") {}
        proc = Proc.new { after_all_ran = true }
        Example.after(:each, &proc)
        suite = @behaviour.suite
        suite.run(@result) {}
        after_all_ran.should be_true

        after_all_ran = false
        Example.remove_after(:each, &proc)
        suite = @behaviour.suite
        suite.run(@result) {}
        after_all_ran.should be_false
      end
    end

    describe "Example", ".include" do
      it_should_behave_like "Spec::DSL::Example"

      it "should have accessible class methods from included module" do
        mod1_method_called = false
        mod1 = Module.new do
          class_methods = Module.new do
            define_method :mod1_method do
              mod1_method_called = true
            end
          end

          metaclass.class_eval do
            define_method(:included) do |receiver|
              receiver.extend class_methods
            end
          end
        end

        mod2_method_called = false
        mod2 = Module.new do
          class_methods = Module.new do
            define_method :mod2_method do
              mod2_method_called = true
            end
          end

          metaclass.class_eval do
            define_method(:included) do |receiver|
              receiver.extend class_methods
            end
          end
        end

        @behaviour.include mod1, mod2

        @behaviour.mod1_method
        @behaviour.mod2_method
        mod1_method_called.should be_true
        mod2_method_called.should be_true
      end
    end

    describe "Example", ".number_of_examples" do
      it_should_behave_like "Spec::DSL::Example"

      it "should count number of specs" do
        @behaviour.example_definitions.clear
        @behaviour.it("one") {}
        @behaviour.it("two") {}
        @behaviour.it("three") {}
        @behaviour.it("four") {}
        @behaviour.number_of_examples.should == 4
      end
    end

    class ExampleModuleScopingSpec < Example
      describe Example, " via a class definition"

      module Foo
        module Bar
          def self.loaded?
            true
          end
        end
      end
      include Foo

      it "should understand module scoping" do
        Bar.should be_loaded
      end

      @@foo = 1

      it "should allow class variables to be defined" do
        @@foo.should == 1
      end      
    end

    class ExampleClassVariablePollutionSpec < Example
      describe Example, " via a class definition without a class variable"

      it "should not retain class variables from other Example classes" do
        proc do
          @@foo
        end.should raise_error
      end
    end

    describe "Example", ".class_eval" do
      it_should_behave_like "Spec::DSL::Example"

      it "should allow constants to be defined" do
        behaviour = Class.new(Example).describe('example') do
          FOO = 1
          it "should reference FOO" do
            FOO.should == 1
          end
        end
        suite = behaviour.suite
        suite.run(@result) {}
        Object.const_defined?(:FOO).should == false
      end
    end

    describe Example, '.run functional example' do
      def count
        @count ||= 0
        @count = @count + 1
        @count
      end

      before(:all) do
        count.should == 1
      end

      before(:all) do
        count.should == 2
      end

      before(:each) do
        count.should == 3
      end

      before(:each) do
        count.should == 4
      end

      it "should run before(:all), before(:each), example, after(:each), after(:all) in order" do
        count.should == 5
      end

      after(:each) do
        count.should == 7
      end

      after(:each) do
        count.should == 6
      end

      after(:all) do
        count.should == 9
      end

      after(:all) do
        count.should == 8
      end
    end

    describe Example, "#initialize" do
      the_behaviour = self
      it "should have copy of behaviour" do
        the_behaviour.superclass.should == Example
      end
    end

    describe Example, "#pending" do
      it "should raise a Pending error when its block fails" do
        block_ran = false
        lambda {
          pending("something") do
            block_ran = true
            raise "something wrong with my example"
          end
        }.should raise_error(Spec::DSL::ExamplePendingError, "something")
        block_ran.should == true
      end

      it "should raise Spec::DSL::PendingFixedError when its block does not fail" do
        block_ran = false
        lambda {
          pending("something") do
            block_ran = true
          end
        }.should raise_error(Spec::DSL::PendingFixedError, "Expected pending 'something' to fail. No Error was raised.")
        block_ran.should == true
      end
    end
    
    describe Example, "#run" do
      before do
        @options = ::Spec::Runner::Options.new(StringIO.new, StringIO.new)
        @original_rspec_options = $rspec_options
        $rspec_options = @options
      end

      after do
        $rspec_options = @original_rspec_options
      end

      it "should not run when there are no example_definitions" do
        behaviour = Class.new(Example).describe("Foobar") {}
        behaviour.example_definitions.should be_empty

        reporter = mock("Reporter")
        reporter.should_not_receive(:add_behaviour)
        suite = behaviour.suite
        suite.run(@result) {}
      end
    end
    
    class ExampleSubclass < Example
    end

    describe "Example", " subclass" do
      it "should have access to the described_type" do
        behaviour = Class.new(ExampleSubclass).describe(ExampleDefinition){}
        behaviour.send(:described_type).should == ExampleDefinition
      end

      it "should figure out its behaviour_type based on its name ()" do
        behaviour = Class.new(ExampleSubclass).describe(ExampleDefinition){}
        behaviour.send(:behaviour_type).should == :subclass
      end

      # TODO - add an example about shared behaviours
    end

    describe Enumerable do
      def each(&block)
        ["4", "2", "1"].each(&block)
      end

      it "should be included in example_definitions because it is a module" do
        map{|e| e.to_i}.should == [4,2,1]
      end
    end

    describe "An", Enumerable, "as a second argument" do
      def each(&block)
        ["4", "2", "1"].each(&block)
      end

      it "should be included in example_definitions because it is a module" do
        map{|e| e.to_i}.should == [4,2,1]
      end
    end

    describe String do
      it "should not be included in example_definitions because it is not a module" do
        lambda{self.map}.should raise_error(NoMethodError, /undefined method `map' for/)
      end
    end
  end
end
