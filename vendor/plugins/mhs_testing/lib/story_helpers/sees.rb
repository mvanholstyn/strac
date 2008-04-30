module MHS
  module Testing
    module Sees
      def see_an_error_explanation
        matches = assert_select '#errorExplanation', "error".to_regexp
        yield matches.first if block_given?
      end  

      def see_an_error(message)
        assert_select '#error', message
      end
  
      def see_message(message, id="notice")
        if response.content_type == "text/javascript"
          response.should have_rjs(:replace_html, id, message)
        else
          response.should have_tag("##{id}", message)
        end
      end
    end
  end
end

RailsStory.class_eval do
  include MHS::Testing::Sees
end