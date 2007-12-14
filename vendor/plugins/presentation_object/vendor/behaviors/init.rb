if RAILS_ENV == 'test'
	require 'behaviors'
	class Test::Unit::TestCase
		extend Behaviors
	end
end
