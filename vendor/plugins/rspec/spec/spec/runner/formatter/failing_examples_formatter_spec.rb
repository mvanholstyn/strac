require File.dirname(__FILE__) + '/../../../spec_helper'

module Spec
  module Runner
    module Formatter
      describe "FailingExamplesFormatter" do
        before(:each) do
          @io = StringIO.new
          @options = Options.new(StringIO.new, @io)
          @formatter = @options.create_formatter(FailingExamplesFormatter)
          @behaviour = Class.new(::Spec::DSL::Example).describe("My Behaviour")
        end

        it "should add example name for each failure" do
          @formatter.add_behaviour("b 1")
          @formatter.example_failed(@behaviour.create_example_definition("e 1"), nil, Reporter::Failure.new(nil, RuntimeError.new))
          @formatter.add_behaviour("b 2")
          @formatter.example_failed(@behaviour.create_example_definition("e 2"), nil, Reporter::Failure.new(nil, RuntimeError.new))
          @formatter.example_failed(@behaviour.create_example_definition("e 3"), nil, Reporter::Failure.new(nil, RuntimeError.new))
          @io.string.should eql(<<-EOF
b 1 e 1
b 2 e 2
b 2 e 3
EOF
)
        end
      end
    end
  end
end
