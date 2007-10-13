require File.dirname(__FILE__) + '/../spec_helper'

describe UniqueCodeGenerator, "#generate" do
  it "generates a unique code given a string and time" do
    string = "foo"
    utc = Time.now.utc
    
    srand 2
    code = UniqueCodeGenerator.generate string, utc
    srand 2
    
    expected_code = Digest::SHA1.hexdigest( "#{string}#{utc.to_s.split(//).sort_by{rand}.join}" )
    assert_equal expected_code, code, "wrong generated code"
  end
  
  
end
