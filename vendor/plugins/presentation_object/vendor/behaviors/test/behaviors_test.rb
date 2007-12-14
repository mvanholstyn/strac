require 'test/unit'
require File.expand_path(File.dirname(__FILE__)) + '/../lib/behaviors'
require 'stringio'

class Dog < Test::Unit::TestCase
  extend Behaviors
  attr_accessor :fed

  alias_method :orig_run, :run #tuck run out of the way so DeveloperTest does not have test methods run at_exit
  def run(result)
  end

  should 'be fed' do
    @fed = true
  end
end

loading_developer_test_class_stdout = StringIO.new
saved_stdout = $stdout.dup
$stdout = loading_developer_test_class_stdout

class DeveloperTest < Test::Unit::TestCase
  extend Behaviors

  attr_accessor :tests_code, :studies, :work_snack, :home_snack, 
                :study_atmosphere, :rest_atmosphere, :unlimited_power, 
                :work_atmosphere, :has_been_setup, :developer, :status,
                :logic_errors


  alias_method :orig_run, :run #tuck run out of the way so DeveloperTest does not have test methods run at_exit
  def run(result)
  end

  def setup
    @snack = 'yogurt'
  end

  def have_unlimited_power
    @unlimited_power = true
  end

  context 'developer at home' do
    setup do
      @noise_level = 'quiet'
    end

    should 'study' do
      @studies = true
      @home_snack = @snack
      @study_atmosphere = @noise_level
    end

    should 'rest' do
      @rest_atmosphere = @noise_level 
    end
  end

  context 'developer at work' do
    should 'test their code' do
      @has_been_setup = @setup
      @tests_code = true 
      @work_snack = @snack
      @noise_level ||= nil
      @work_atmosphere = @noise_level
      have_unlimited_power
    end

    setup do
      @setup = true
    end

    should 'go to meetings'
    
    SHOULD 'not go to meetings' do
    end
  end
  
  define_context 'a developer' do
    @developer = "Martin Fowler"
  end
  
  define_context "when asleep" do
    @rest_atmosphere = 'unconscious'
  end
  
  context "a developer" do
    context "when asleep" do
      should "be unconscious" do
        @status = [@developer, ' is ', @rest_atmosphere].join
      end
    end

    should "not rest by default" do
      @status = [@developer, "'s rest atmosphere is ", @rest_atmosphere.inspect].join
    end
    
    context "when asleep" do
      setup do
        @rest_atmosphere = 'dreaming'
      end
      
      should "be dreaming" do
        @status = [@developer, ' is ', @rest_atmosphere].join
      end
    end
  end

  context "a developer" do
    context "when asleep" do
      should "not be woken by custom setups" do
        @status = [@developer, ' is still ', @rest_atmosphere].join
      end
    end
  end
end

$stdout = saved_stdout
loading_developer_test_class_stdout.rewind
$loading_developer_test_class_output = loading_developer_test_class_stdout.read


class BehaviorsTest < Test::Unit::TestCase

  def setup
    @developer_test_suite = DeveloperTest.suite
  end

  #
  # TESTS
  #
  def test_should_called_with_a_block_defines_a_test
    at_work_test = @developer_test_suite.tests.find {|test| test.method_name == 'test developer at work should test their code'}
    at_home_test = @developer_test_suite.tests.find {|test| test.method_name == 'test developer at home should study'}

    assert_nil at_work_test.tests_code, 'should be nil until test method called'
    assert_nil at_home_test.studies, 'should be nil until test method called'

    at_work_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}
    at_home_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}

    assert at_work_test.tests_code, 'should be true after test method called'
    assert at_home_test.studies, 'should be true after test method called'
  end

  def test_should_called_without_a_block_does_not_create_a_test_method
    assert !@developer_test_suite.tests.any? {|test| test.method_name =~ /test.should_go.to.meetings/ }, 'should not have defined test method'
  end
  
  def test_SHOULD_called_with_a_block_does_not_create_a_test_method
    assert !@developer_test_suite.tests.any? {|test| test.method_name =~ /test.should_not_go.to.meetings/ }, 'should not have defined test method'    
  end

  def test_contexts_will_share_test_case_setup
    at_work_test = @developer_test_suite.tests.find {|test| test.method_name == 'test developer at work should test their code'}
    at_home_test = @developer_test_suite.tests.find {|test| test.method_name == 'test developer at home should study'}

    assert_nil at_work_test.work_snack, 'work snack should not be defined'
    assert_nil at_home_test.home_snack, 'home snack should not be defined'

    at_work_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}
    at_home_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}

    assert_equal 'yogurt', at_work_test.work_snack, 'wrong home snack'     
    assert_equal 'yogurt', at_home_test.home_snack, 'wrong home snack'     
  end

  def test_contexts_can_make_calls_to_helpers_defined_outside_of_the_context
    at_work_test = @developer_test_suite.tests.find {|test| test.method_name == 'test developer at work should test their code'}

    assert_nil at_work_test.unlimited_power, 'should not have unlimited power yet'

    at_work_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}
    assert at_work_test.unlimited_power, 'should have unlimited power'
  end

  def test_contexts_can_have_their_own_setup_that_will_be_invoked_before_each_should
    at_home_study_test = @developer_test_suite.tests.find {|test| test.method_name == 'test developer at home should study'}
    at_home_rest_test = @developer_test_suite.tests.find {|test| test.method_name == 'test developer at home should rest'}

    assert_nil at_home_study_test.study_atmosphere, 'study atmosphere should not be defined'
    assert_nil at_home_rest_test.rest_atmosphere, 'rest atmosphere should not be defined'

    at_home_study_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}
    at_home_rest_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}

    assert_equal 'quiet', at_home_study_test.study_atmosphere, 'wrong study atmosphere'
    assert_equal 'quiet', at_home_rest_test.rest_atmosphere, 'wrong rest atmosphere'
  end

  def test_setup_can_be_placed_anywhere_in_a_context
    at_work_test = @developer_test_suite.tests.find {|test| test.method_name == 'test developer at work should test their code'}

    assert_nil at_work_test.unlimited_power, 'should not have unlimited power yet'

    at_work_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}
    assert at_work_test.has_been_setup, 'should have called setup'
  end

  def test_a_context_does_get_polluted_with_instance_variables_from_another_context
    at_home_study_test = @developer_test_suite.tests.find {|test| test.method_name == 'test developer at home should study'}
    assert_nil at_home_study_test.study_atmosphere, 'study atmosphere should not be defined'
    
    at_home_study_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}
    assert_equal 'quiet', at_home_study_test.study_atmosphere, 'wrong study atmosphere'


    at_work_test = @developer_test_suite.tests.find {|test| test.method_name == 'test developer at work should test their code'}
    assert_nil at_work_test.work_atmosphere, 'work atmosphere should not be defined'

    at_work_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}
    assert_nil at_work_test.work_atmosphere, 'work atmosphere should not be defined'
  end

  def test_should_called_without_a_block_will_give_unimplemented_output_when_class_loads
    unimplemented_output = 'UNIMPLEMENTED CASE: developer at work should go to meetings'
    assert_match(/#{unimplemented_output}/, $loading_developer_test_class_output)
  end
  
  def test_SHOULD_called_with_a_block_will_give_unimplemented_output_when_class_loads
    unimplemented_output = 'UNIMPLEMENTED CASE: developer at work should not go to meetings'
    assert_match(/#{unimplemented_output}/, $loading_developer_test_class_output)
  end

  def test_can_use_shoulds_without_a_context
    dog_suite = Dog.suite
    fed_test = dog_suite.tests.find {|test| test.method_name == 'test should be fed'} 
    assert_nil fed_test.fed, 'fed should not be defined yet'
    fed_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}
    assert fed_test.fed, 'fed should be true'
  end

  def test_contexts_without_a_block_will_raise
    assert_not_nil @@context_without_block_error, 'should have thrown an error'
    assert_equal RuntimeError, @@context_without_block_error.class, 'wrong error type'
    assert_match(/context: 'this will not work' called without a block/, @@context_without_block_error.message, 'wrong error message')
  end

  def test_defining_two_setups_in_context_will_raise
    assert_not_nil @@context_without_block_error, 'should have thrown an error'
    assert_equal RuntimeError, @@two_setups_error.class, 'wrong error type'
    assert_equal "Can't define two setups within one context", @@two_setups_error.message
  end
  
  def test_contexts_can_be_embedded
    asleep_test = @developer_test_suite.tests.find {|test| test.method_name == 'test a developer when asleep should be unconscious'}

    asleep_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}

    assert_equal 'Martin Fowler is unconscious', asleep_test.status, 'wrong status'
  end
  
  def test_setup_method_overrides_defined_setup
    asleep_test = @developer_test_suite.tests.find {|test| test.method_name == 'test a developer when asleep should be dreaming'}

    asleep_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}

    assert_equal 'Martin Fowler is dreaming', asleep_test.status, 'wrong status'
  end
  
  def test_shoulds_in_parent_context_do_not_use_setups_from_child_contexts
    asleep_test = @developer_test_suite.tests.find {|test| test.method_name == 'test a developer should not rest by default'}

    asleep_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}

    assert_equal "Martin Fowler's rest atmosphere is nil", asleep_test.status, 'wrong status'
  end
  
  def test_defined_setups_are_reusable
    asleep_test = @developer_test_suite.tests.find {|test| test.method_name == 'test a developer when asleep should not be woken by custom setups'}

    asleep_test.orig_run(Test::Unit::TestResult.new) {|result,progress_block|}

    assert_equal "Martin Fowler is still unconscious", asleep_test.status, 'wrong status'
  end
  

  begin
    class BoomBoom < Test::Unit::TestCase
      extend Behaviors

      alias_method :orig_run, :run #tuck run out of the way so Test does not have test methods run at_exit
      def run(result)
      end

      context 'this will not work'
    end
  rescue => err
    @@context_without_block_error = err
  end

  begin
    class TwoSetups < Test::Unit::TestCase
      extend Behaviors

      alias_method :orig_run, :run #tuck run out of the way so Test does not have test methods run at_exit
      def run(result)
      end

      context 'two setups will raise' do
        setup do
        end
        setup do
        end
      end
    end
  rescue => err
    @@two_setups_error = err
  end

end
