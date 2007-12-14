require 'rake'
require 'rake/tasklib'
require 'test/unit/collector/dir'
require 'test/unit' 

module Behaviors
include Rake

  class ReportTask < TaskLib
    attr_accessor :pattern
    attr_accessor :html_dir

    def initialize(name=:behaviors)
      Test::Unit.run=true
      @name = name
      @html_dir = 'doc'
      yield self if block_given?
      define
    end

    def define
      desc "List behavioral definitions for the classes specified (use for=<regexp> to further limit files included in report)"
      task @name do
        specifications.each do |spec|
           puts "#{spec.name}:"
           spec.contexts.each do |context|
             context_string = " - #{context.name}"
             context_string << ' ' unless context.name.empty?
             context_string << 'should:'
             puts context_string
             context.behaviors.each do |behavior|
               puts "   - #{behavior}"
             end
           end
        end
      end

      desc "Generate html report of behavioral definitions for the classes specified (use for=<regexp> to further limit files included in report)"
      task "#{@name}_html" do
        require 'erb'
        txt =<<-EOS 
<html>
<head>
<style>

div.title
{
  width: 600px;
  font: bold 14pt trebuchet ms;
}

div.specification 
{
  font: bold 12pt trebuchet ms;
  border: solid 1px black;
  width: 600px;
  padding: 5px;
  margin: 5px;
}

ul.context
{
  font: normal 11pt verdana;
  padding-left: 0;
  margin-left: 0;
  border-bottom: 1px solid gray;
  border-top: 1px solid gray;
  width: 600px;
}

ul.context li
{
  list-style: none;
  margin: 0;
  padding: 0.25em;
}

ul.requirements
{
  font: normal 11pt verdana;
  padding-left: 20;
  margin-left: 0;
  width: 600px;
}

ul.requirements li
{
  list-style: none;
  margin: 0;
  padding: 0.25em;
}

</style>
</head>
<body>
<div class="title">Specifications</div>
<% specifications.each do |spec| %>
<div class="specification">
<%= spec.name %>
  <% spec.contexts.each do |context| %>
  <ul class="context">
  <li><%= context.name + ' ' %>should</li>
    <ul class="requirements">
    <% context.behaviors.each do |behavior| %>
      <li><%= behavior %></li>
    <% end %>
    </ul>
  </ul>
  <% end %>
  </div>
<% end %>
</body>
</html>
EOS
        output_dir = File.expand_path(@html_dir)
        mkdir_p output_dir
        output_filename = output_dir + "/behaviors.html"
        File.open(output_filename,"w") do |f|
          f.write ERB.new(txt).result(binding)
        end
        puts "(Wrote #{output_filename})"
      end
    end

    def collect_methods(test_suite,collected_test_classes=nil)
      collected_test_classes ||= {}
      test_suite.each do |test|
        if test.class < Test::Unit::TestCase
          collected_test_classes[test.class.to_s] ||= []
          collected_test_classes[test.class.to_s] << test.method_name
        end
        collect_methods(test.tests,collected_test_classes) if test.class == Test::Unit::TestSuite
      end
      collected_test_classes
    end

    def collected_test_classes
      @pattern << '\z'
      collector = Test::Unit::Collector::Dir.new
      collector.pattern << (Regexp.new(@pattern))
      collected_tests = collector.collect('.').tests
      collect_methods(collected_tests)
    end 

    def specifications
      specs = {}
      test_classes = collected_test_classes
      test_classes.each do |test_class,method_names|
        class_name = test_class.gsub('Test','')
        specs[class_name] ||= {} 
        method_names.each do |method_name|
          context, behavior = method_name.split('should')
          context.gsub!('test','').strip!
          behavior.strip!
          specs[class_name][context] ||= [] 
          specs[class_name][context] << behavior
        end
      end

      spec_structs = []
      specs.each do |class_name,contexts|
        spec_structs << OpenStruct.new(:name => class_name, :contexts => [])    
        contexts.each do |context,behaviors|
          spec_structs.last.contexts << OpenStruct.new(:name => context, :behaviors => behaviors) 
        end
      end 
      spec_structs
    end
  end
end
