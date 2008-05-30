require File.dirname(__FILE__) + '/../spec_helper'

describe StoryTagsPresenter, '#each' do
  before do
    @tags = [ 
      stub("foo tag", :name => "foo", :id => 1),
      stub("bar tag", :name => "bar", :id => 2) ]
    @presenter = StoryTagsPresenter.new :tags => @tags, :project => nil
  end
  
  it "iterates over the tags in alphabetical order" do
    @tags.first.stub!(:name).and_return("foo")
    @tags.last.stub!(:name).and_return("bar")
    names = []
    @presenter.each do |tag|
      names << tag.name
    end
    names.should == [ "bar", "foo" ]
  end
end

describe StoryTagsPresenter, "#empty?" do
  it "is empty with no tags" do
    @iterations_presenter = StoryTagsPresenter.new :tags=>[], :project => Project.new
    @iterations_presenter.empty?.should be_true
  end
  
  it "is not empty with tags" do
    @iterations_presenter = StoryTagsPresenter.new :tags=>["tag1"], :project => Project.new
    @iterations_presenter.empty?.should be_false
  end
end


describe StoryTagsPresenter, '#tagless' do
  before do
    @presenter = StoryTagsPresenter.new :tags => nil, :project => nil
  end
  
  it "returns a new Tag" do
    Tag.should_receive(:new).and_return(:tag)
    @presenter.tagless.should == :tag
  end
end

describe StoryTagsPresenter, '#tagless_stories' do
  before do
    @project = stub("project", :tagless_stories => nil)
    @presenter = StoryTagsPresenter.new :tags => @tags, :project => @project
  end

  it "returns the tagless_stories from the passed in project" do
    tagless_stories = stub("tag less stories")
    @project.should_receive(:tagless_stories).and_return(tagless_stories)
    @presenter.tagless_stories.should == tagless_stories
  end
end


