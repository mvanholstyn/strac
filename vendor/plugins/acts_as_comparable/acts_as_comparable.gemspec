require 'rake'

Gem::Specification.new do |s|
  s.name = %q{acts_as_comparable}
  s.version = "1.2"
  s.date = %q{2007-04-20}
  s.summary = %q{Adds ActiveRecord model comparison functionality.}
  s.email = %q{mvette13@gmail.com zach.dennis@gmail.com}
  s.homepage = %q{http://www.continuousthinking.com/tags/acts_as_comparable}
  s.rubyforge_project = %q{arext}
  s.description = %q{Adds ActiveRecord model comparison functionality.}
  s.require_path = 'lib'
  s.autorequire = "acts_as_comparable.rb"
  s.has_rdoc = true
  s.authors = ["Mark Van Holstyn", "Zach Dennis" ]
  s.files = FileList[ 'init.rb', 'Rakefile', 'ChangeLog', 'LICENSE', 'README', 'lib/**/*.rb', 'test/**/*' ]
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
  s.add_dependency(%q<activerecord>, [">= 1.14.1"])
end
