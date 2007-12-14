require File.dirname(__FILE__) + '/../spec_helper'

describe StoryTagsPresenter, '#each' do
  before do
    @tags = [ 
      stub("foo tag", :name => "foo", :id => 1),
      stub("bar tag", :name => "bar", :id => 2) ]
    @presenter = StoryTagsPresenter.new :tags => @tags, :project => nil
  end
  
  it "iterates over the tags" do
    @tags.first.should_receive(:name)
    @tags.last.should_receive(:name)
    @presenter.each do |tag|
      tag.name
    end
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


