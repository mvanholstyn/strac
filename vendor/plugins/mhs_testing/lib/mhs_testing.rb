Dir[File.join(File.dirname(__FILE__), 'it_helpers/*.rb')].each{ |f| require f }
Dir[File.join(File.dirname(__FILE__), 'core_helpers/*.rb')].each{ |f| require f }
Dir[File.join(File.dirname(__FILE__), 'controller_helpers/*.rb')].each{ |f| require f }
Dir[File.join(File.dirname(__FILE__), 'model_helpers/*.rb')].each{ |f| require f }
Dir[File.join(File.dirname(__FILE__), 'view_helpers/*.rb')].each{ |f| require f }
Dir[File.join(File.dirname(__FILE__), 'story_helpers/*.rb')].each{ |f| require f }
Dir[File.join(File.dirname(__FILE__), 'matchers/*.rb')].each{ |f| require f }

Spec::Runner.configure do |config|
  config.include ValidationMatchers, AssociationMatchers
end

require File.join(File.dirname(__FILE__), 'selenium')
require File.join(RAILS_ROOT, 'config', 'selenium', 'osx') if File.exist?(File.join(RAILS_ROOT, 'config', 'selenium', 'osx.rb'))
