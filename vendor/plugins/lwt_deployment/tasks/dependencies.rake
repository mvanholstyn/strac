# Formatted as package name, friendly version, command to execute, successful regex, version regex
# @dependancies = [
#   ['ruby',      '1.8.4 or 1.8.5', 'ruby -v',                                                          /ruby (1\.8\.[4-5])/,         /\d\.\d\.\d/],
#   ['rake',      '0.x.x',          'rake --version',                                                   /rake, version (\d\.\d\.\d)/, /\d\.\d\.\d/],
#   ['python',    '2.4.x',          'python -V',                                                        /Python (2\.4\.\d)/,          /\d\.\d\.\d/],
#   ['pyro',      '3.x',            'python -c "import Pyro.core; print Pyro.core.constants.VERSION"',  /3\.\d/,                      /\d\.\d/],
#   ['pil',       '1.1.x',          'python -c "import Image; print Image.VERSION"',                    /1\.1\.\d/,                   /\d\.\d\.\d/],
#   ['mysql',     '5.0.x',          'mysql -V',                                                         /Distrib (5\.0\.\d+)/,        /\d\.\d\.\d+/],
#   ['lighttpd',  '1.4.x',          'lighttpd -v',                                                      /lighttpd-(1\.4\.\d+)/,       /\d\.\d\.\d+/],
# ]
# 
# namespace :dependencies do
#   desc ""
#   task :check do
#     require 'activesupport'
#     require 'colored'
#   
#     installed = []
#     uninstalled = []
#   
#     @dependancies.each do |dep|
#       data = `#{dep[2]} 2>&1`
#     
#       if data =~ /command not found/
#         uninstalled << "#{dep[0].upcase} is not installed (or isn't in your path). Please install version #{dep[1]}."
#       else
#         if not data =~ dep[3]
#           if data =~ dep[4]
#             uninstalled << "#{dep[0].upcase} version incorrect! #{dep[1]} required, but found #{$~[0]}"
#           else
#             uninstalled << "#{dep[0].upcase} version incorrect! #{dep[1]} required, but found undetermined version"
#           end
#         else
#           installed << "#{dep[0].upcase} (#{dep[1]}) is installed correctly."
#         end
#       end
#     end
#   
#     puts installed.map(&:green)
#     puts uninstalled.map(&:red)
#   end
# end
