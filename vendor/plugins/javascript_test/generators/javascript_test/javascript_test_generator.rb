class JavascriptTestGenerator < Rails::Generator::NamedBase  

  def manifest
    record do |m|
      m.directory File.join("test","javascript")      
      m.directory File.join("test","javascript", 'helpers')      
      m.template 'javascript_test.js', File.join('test/javascript', "#{name}_test.js")
    end
  end
end
