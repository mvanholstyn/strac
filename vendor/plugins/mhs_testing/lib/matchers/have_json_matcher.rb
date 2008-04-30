# thx http://faithfulcode.rubyforge.org/svn/plugins/trunk/spec_goodies/lib/spec/goodies/matchers/json.rb
module Spec
  module Matchers
    
    begin
      require 'json'
    rescue MissingSourceFile => e
      # no support for json
    end
    
    class HaveJson # :nodoc:
      def initialize(expected, strict = true)
        @strict = strict
        @expected = case
          when expected.kind_of?(String): JSON.parse(expected)
          when expected.respond_to?(:to_json): JSON.parse(expected.to_json)
          else raise "Expected have_json to be called with an object that can be converted to JSON but instead received #{expected.class}"
        end
      end
      
      def matches?(actual)
        @actual = actual.kind_of?(String) ? actual : actual.body
        begin
          if @strict
            @expected == JSON.parse(@actual)
          else
            @expected == JSON.parse(@actual).slice(*@expected.keys)
          end
        rescue
          @failure_message = "actual value <#{@actual.inspect}> is not JSON"
          false
        end
      end
      
      def failure_message
        @failure_message || "expected <#{@actual.inspect}> to contain JSON <#{@expected.inspect}>"
      end
      
      def negative_failure_message
        "expected <#{@actual.inspect}> not to contain JSON <#{@expected}>"
      end
    end
    
    # Specify that a String or an object responding to :body matches the
    # expected JSON content, given as a String or an object responding to
    # :to_json (like a Hash). Requires that you install the json gem.
    #
    # The matching is done by parsing the actual and expected JSON, thereby
    # converting them into Ruby structures. Equality is then decided by
    # using ==.
    #
    #    "{something: 'value'}".should have_json(:something => "value")
    #    response.should have_json(:something => "value")
    #
    # Note that at present, substrings are not handled. That is, given a
    # large document with a JSON String in it, this will fail, as it must
    # match completely. In Rails, css_select is your friend ;)
    def have_json(expected)
      HaveJson.new(expected)
    end
    
    def contain_json(expected)
      HaveJson.new(expected, false)
    end
    
  end
end