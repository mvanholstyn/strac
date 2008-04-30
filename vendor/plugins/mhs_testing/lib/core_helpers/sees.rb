module MHS
  module Testing
    module Sees
      def see_an_error_explanation
        matches = assert_select '#errorExplanation', "error".to_regexp
        yield matches.first if block_given?
      end  
    end
  end
end

RailsStory.class_eval do
  include MHS::Testing::Sees
end