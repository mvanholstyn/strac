# extend the existing Tag class
Tag.class_eval do
  
  # This is to be used over a has_many_polymorphs in the context of the class
  # during parse time since has_many_polymorphs forces all of the models involved to load. 
  # This fails if you check the project out and try to run the migrations. The
  # fix is to put the declaration inside of the 'stories' method so it loads on first use. 
  def stories
    self.class.has_many_polymorphs :taggables, :from => [:stories], :through => :taggings
    stories
  end
end
