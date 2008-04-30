module RailsSeleniumStory::Matchers
end

Dir[File.dirname(__FILE__) + '/matchers/*.rb'].each { |f| require f }