require 'test/unit'

begin
  require File.dirname(__FILE__) + '/../../../../config/boot'
  require 'active_record'
rescue LoadError
  require 'rubygems'
  require_gem 'activerecord'
end

require 'active_record/fixtures'

require File.dirname(__FILE__) + '/../lib/acts_as_taggable'
require File.dirname(__FILE__) + '/../lib/tag'
require File.dirname(__FILE__) + '/../lib/tagging'
require File.dirname(__FILE__) + '/../lib/tag_counts_extension'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'mysql'])

load(File.dirname(__FILE__) + '/schema.rb')

Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + '/fixtures/'
$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)

class Test::Unit::TestCase #:nodoc:
  def create_fixtures(*table_names)
    if block_given?
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names) { yield }
    else
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names)
    end
  end

  # Turn off transactional fixtures if you're working with MyISAM tables in MySQL
  self.use_transactional_fixtures = true
  
  # Instantiated fixtures are slow, but give you @david where you otherwise would need people(:david)
  self.use_instantiated_fixtures  = false
  
  def assert_equivalent(expected, actual, message = nil)
    if expected.first.is_a?(ActiveRecord::Base)
      assert_equal expected.sort_by(&:id), actual.sort_by(&:id), message
    else
      assert_equal expected.sort, actual.sort, message
    end
  end
  
  def assert_tag_counts(tags, expected_values)
    # Map the tag fixture names to real tag names
    expected_values = expected_values.inject({}) do |hash, (tag, count)|
      hash[tags(tag).name] = count
      hash
    end
    
    tags.each do |tag|
      value = expected_values.delete(tag.name)
      assert_not_nil value, "Expected count for #{tag.name} was not provided" if value.nil?
      assert_equal value, tag.count, "Expected value of #{value} for #{tag.name}, but was #{tag.count}"
    end
    
    unless expected_values.empty?
      assert false, "The following tag counts were not present: #{expected_values.inspect}"
    end
  end
end
