constructor

* http://rubyforge.org/projects/atomicobjectrb/
* http://atomicobjectrb.rubyforge.org/constructor

== DESCRIPTION:
  
Declarative means to define object properties by passing a hash 
to the constructor, which will set the corresponding ivars.

== FEATURES/PROBLEMS:
  
* Declarative constructor definition and ivar initialization 

== SYNOPSIS:

  require 'constructor'

  class Horse
    constructor :name, :breed, :weight
  end
  Horse.new :name => 'Ed', :breed => 'Mustang', :weight => 342

By default the ivars do not get accessors defined.
But you can get them auto-made if you want:

  class Horse
    constructor :name, :breed, :weight, :accessors => true
  end
  ...
  puts my_horse.weight
 
Arguments specified are required by default.  You can disable 
strict argument checking with :strict option.  This means that 
the constructor will not raise an error if you pass more or 
fewer arguments than declared.

  class Donkey
    constructor :age, :odor, :strict => false
  end

... this allows you to pass either an age or odor key (or neither)
to the Donkey constructor.


== REQUIREMENTS:

* rubygems

== INSTALL:

* sudo gem install constructor

== LICENSE:

(The MIT License)

Copyright (c) 2007 Atomic Object

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
