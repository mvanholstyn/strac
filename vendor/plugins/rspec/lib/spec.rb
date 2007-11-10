require 'test/unit'

dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/spec/version")
require File.expand_path("#{dir}/spec/matchers")
require File.expand_path("#{dir}/spec/expectations")
require File.expand_path("#{dir}/spec/translator")
require File.expand_path("#{dir}/spec/dsl")
require File.expand_path("#{dir}/spec/extensions")
require File.expand_path("#{dir}/spec/runner")
require File.expand_path("#{dir}/spec/story")
require File.expand_path("#{dir}/spec/test")
module Spec
  class << self
    def run?
      @run || rspec_options.examples_run?
    end

    def run; \
      return true if run?; \
      result = rspec_options.run_examples; \
      @run = true; \
      result; \
    end
    attr_writer :run
  end
end
