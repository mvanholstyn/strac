require 'test/unit'
here = File.expand_path(File.dirname(__FILE__))
require "#{here}/../../../lib/behaviors"
require "#{here}/../lib/user"

class UserTest < Test::Unit::TestCase
  extend Behaviors

  def setup
    @user = User.new('edith',18)
  end

  context 'when constructing' do
    should 'set name and age accessors' do
      assert_equal 'edith', @user.name
      assert_equal 18, @user.age
    end
  end

  context 'given a constructed instance' do
    should 'be an adult if age is 18' do
      assert @user.adult?, 'should be an adult'
    end
  end

  should 'allow name to be changed' do
    assert_equal 'edith', @user.name
    @user.name = 'bonnie' 
    assert_equal 'bonnie', @user.name
  end

  should 'allow age to be changed' do
    assert_equal 18, @user.age
    @user.age = 30
    assert_equal 30, @user.age
  end
end
