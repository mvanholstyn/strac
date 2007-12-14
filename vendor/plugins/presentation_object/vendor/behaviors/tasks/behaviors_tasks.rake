$LOAD_PATH << File.join(File.dirname(__FILE__), "../lib/")

if !self.class.const_defined?('APP_ROOT')
  APP_ROOT = RAILS_ROOT if self.class.const_defined?('RAILS_ROOT')
end


desc "List behavioral definitions for the classes under test (use for=<term> also)"
task :behaviors do
  require 'behaviors'
  require 'behaviors/reporttask'
  
  Behaviors::ReportTask.new do |t|
    t.pattern = 'test/**/*_test.rb'
  end
  
  # specifications.each do |spec|
  #   puts "#{spec.name} should:\n"
  #   spec.requirements.each do |req|
  #     puts " - #{req}"
  #   end
  # end
end

desc "List behavioral definitions for the classes under test (HTML output)"
task :behaviors_html do
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

  ul.requirements
  {
    font: normal 11pt verdana;
    padding-left: 0;
    margin-left: 0;
    border-bottom: 1px solid gray;
    width: 600px;
  }

  ul.requirements li
  {
    list-style: none;
    margin: 0;
    padding: 0.25em;
    border-top: 1px solid gray;
  }
  </style>
  </head>
  <body>
  <div class="title">Specifications for <%= title %></div>
  <% specifications.each do |spec| %>
  <div class="specification">
  <%= spec.name %> should: 
  <ul class="requirements">
  <% spec.requirements.each do |req| %>
  <li><%= req %></li>
  <% end %>
  </ul>
  </div>
  <% end %>
  </body>
  </html>
  EOS
  output_dir = File.expand_path("#{APP_ROOT}/doc")
  mkdir_p output_dir
  output_filename = output_dir + "/behaviors.html"
  File.open(output_filename,"w") do |f|
    f.write ERB.new(txt).result(binding)
  end
  puts "(Wrote #{output_filename})"
end

def title
  File.basename(File.expand_path(APP_ROOT))
end

def specifications
  test_files.map do |file|
    spec = OpenStruct.new
    m = %r".*/([^/].*)_test.rb".match(file)
    class_name = titleize(m[1]) if m[1]
    spec.name = class_name
    spec.requirements = []
    File::readlines(file).each do |line| 
      if line =~ /^\s*should\s+\(?\s*["'](.*)["']/
        spec.requirements << $1
      end
    end
    spec
  end
end

def test_files
  test_list = FileList["#{APP_ROOT}/test/**/*_test.rb"]
  if ENV['for'] 
    test_list = test_list.grep(/#{ENV['for']}/i)
  end
  test_list
end  


############################################################
# STOLEN FROM inflector.rb
############################################################
#--
# Copyright (c) 2005 David Heinemeier Hansson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++
def titleize(word)
  humanize(underscore(word)).gsub(/\b([a-z])/) { $1.capitalize }
end    

def underscore(camel_cased_word)    camel_cased_word.to_s.gsub(/::/, '/').
  gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_").downcase
end

def humanize(lower_case_and_underscored_word)
  lower_case_and_underscored_word.to_s.gsub(/_id$/, "").gsub(/_/, " ").capitalize
end
