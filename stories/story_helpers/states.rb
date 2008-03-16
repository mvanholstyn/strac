module LwtTesting
  module States
    def there_are_no_stories_in_the_system
      Story.destroy_all
    end
  end
end

module Spec::Story::World
  include LwtTesting::States
end