module Spec::Story::World
  include ERB::Util
  
  def puts_body
    puts response.body
  end
end