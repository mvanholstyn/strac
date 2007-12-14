require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/expectation_list'
require 'mocha/expectation'
require 'set'
require 'method_definer'

class ExpectationListTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_find_matching_expectation
    expectation_list = ExpectationList.new
    expectation1 = Expectation.new(nil, :my_method).with(:argument1, :argument2)
    expectation2 = Expectation.new(nil, :my_method).with(:argument3, :argument4)
    expectation_list.add(expectation1)
    expectation_list.add(expectation2)
    assert_same expectation2, expectation_list.detect(:my_method, :argument3, :argument4)
  end

  def test_should_find_most_recent_matching_expectation
    expectation_list = ExpectationList.new
    expectation1 = Expectation.new(nil, :my_method).with(:argument1, :argument2)
    expectation2 = Expectation.new(nil, :my_method).with(:argument1, :argument2)
    expectation_list.add(expectation1)
    expectation_list.add(expectation2)
    assert_same expectation2, expectation_list.detect(:my_method, :argument1, :argument2)
  end

  def test_should_find_most_recent_matching_expectation_but_give_preference_to_those_allowing_invocations
    expectation_list = ExpectationList.new
    expectation1 = Expectation.new(nil, :my_method)
    expectation2 = Expectation.new(nil, :my_method)
    expectation1.define_instance_method(:invocations_allowed?) { true }
    expectation2.define_instance_method(:invocations_allowed?) { false }
    expectation_list.add(expectation1)
    expectation_list.add(expectation2)
    assert_same expectation1, expectation_list.detect(:my_method)
  end

  def test_should_find_most_recent_matching_expectation_if_no_matching_expectations_allow_invocations
    expectation_list = ExpectationList.new
    expectation1 = Expectation.new(nil, :my_method)
    expectation2 = Expectation.new(nil, :my_method)
    expectation1.define_instance_method(:invocations_allowed?) { false }
    expectation2.define_instance_method(:invocations_allowed?) { false }
    expectation_list.add(expectation1)
    expectation_list.add(expectation2)
    assert_same expectation2, expectation_list.detect(:my_method)
  end

  def test_should_find_expectations_for_the_same_method_no_matter_what_the_arguments
    expectation_list = ExpectationList.new
    expectation1 = Expectation.new(nil, :my_method).with(:argument1, :argument2)
    expectation_list.add(expectation1)
    expectation2 = Expectation.new(nil, :my_method).with(:argument3, :argument4)
    expectation_list.add(expectation2)
    assert_equal [expectation1, expectation2].to_set, expectation_list.similar(:my_method).to_set
  end
  
  def test_should_ignore_expectations_for_different_methods
    expectation_list = ExpectationList.new
    expectation1 = Expectation.new(nil, :method1).with(:argument1, :argument2)
    expectation_list.add(expectation1)
    expectation2 = Expectation.new(nil, :method2).with(:argument1, :argument2)
    expectation_list.add(expectation2)
    assert_equal [expectation2], expectation_list.similar(:method2)
  end
  
end
