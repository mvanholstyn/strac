# This file contains the receive_and_render matchers for rspec. Three methods are exposed
# to your specs:
#  * during_render
#  * receive_and_render
#  * stub_and_render
#
# Here is a short example:
#   during_render do
#     @event.should receive_and_render(:name)
#   end
#
# during_render is used to setup your and verify your render expectations. It will try to call
# the helper method render_it. The 'render_it' method should perform the actual call to
# render in your view spec. If you don't use render_it and you use a different helper name
# for your project you can change this by setting the render_method. Example:
#    Spec::Matchers::ContinuousThinking::ReceiveAndRender.render_method = "render_now!"
#
# The above example is supposed to be long and grotesk. I'm hoping you keep with the render_it
# convention. ;)
#
# One more thing to note. The 'receive_and_render' method ends up setting a "should_receive"
# expectation on your object. A 'stub_and_render' method also exists which sets up a "stub!"
# expectation on your object. Here's an example:
#   during_render do
#     @event.should stub_and_render(:name)
#   end
#
# Author: Zach Dennis | http://www.continuousthinking.com | zach dot dennis at gmail dot com

module Spec::Matchers

  # Actual matcher that is exposed.  
  def receive_and_render(method2receive, &blk)  
    setup_receive_and_render_matcher ContinuousThinking::ReceiveAndRender.new(:should_receive, method2receive, &blk)  
  end  

  def receive_and_render_html_escaped(method2receive, &blk)  
    setup_receive_and_render_matcher ContinuousThinking::ReceiveAndRender.new(:should_receive, method2receive, :html_escaped => true, &blk)  
  end 
  alias_method :receive_and_render_escaped, :receive_and_render_html_escaped

  # Actual matcher that is exposed.  
  def stub_and_render(method2receive, &blk)  
    setup_receive_and_render_matcher ContinuousThinking::ReceiveAndRender.new(:stub!, method2receive, &blk)  
  end  

  # Actual helper that is exposed.  
  def during_render
    yield
    instance_eval ContinuousThinking::ReceiveAndRender.render_method
    @receive_and_render_matchers.each do |matcher|
      response.should have_tag(matcher.parent_selector) do
        if matcher.html_escaped
          response.should have_text(ERB::Util.html_escape(matcher.text2match).to_regexp)
        else
          response.should have_tag(matcher.selector)
        end
      end
    end
  end
  
  private
  
  def setup_receive_and_render_matcher(matcher)
    @receive_and_render_matchers ||= []
    @receive_and_render_matchers << matcher
    @receive_and_render_matchers.last
  end

  module ContinuousThinking

    class ReceiveAndRender
      attr_accessor :method2receive, :rendered_tag_name, :html_escaped

      class << self
        attr_accessor :render_method
      end
      self.render_method = "render_it"
    
      def initialize(receive_or_stub, method2receive, options={}, &blk)
        @receive_or_stub = receive_or_stub
        @method2receive = method2receive
        @rendered_tag_name = "#{method2receive}_render_and_receive"
        @html_escaped = options[:html_escaped]
        @inside = "*"
      end  
  
      def matches?(target)
        return_value = text2match
        if @args.nil?
          target.send(@receive_or_stub, method2receive).and_return(return_value)
        else
          target.send(@receive_or_stub, method2receive).with(*@args).and_return(return_value)
        end
        true
      end
      
      def parent_selector
        @inside
      end
      
      def inside(selector)
        @inside = selector
        self
      end
      
      def text2match
        %|<p id="#{rendered_tag_name}" />| 
      end
      
      def selector
        "p##{rendered_tag_name}"
      end
      
      def with(*args)
        @args = args
        self
      end
  
      def failure_message  
        "expected to render #{method2receive} in the template"
      end  
      alias_method :negative_failure_message, :failure_message
    end  
  end
  
end  
