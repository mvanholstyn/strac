require File.dirname(__FILE__) + '/../spec_helper'

describe StoriesIndexPresenter, '::VIEWS' do
  it "contains 'iterations' and 'tags" do
    StoriesIndexPresenter::VIEWS == ['iterations', 'tags']
  end
end

describe StoriesIndexPresenter, "#view" do
  describe "when the passed in :view is in the ::VIEWS list" do
    it "returns the passed in view" do
      StoriesIndexPresenter::VIEWS.each do |view|
        StoriesIndexPresenter.new(:view => view).view.should == view
      end
    end
  end
  
  describe "when the passed in :view is not in the ::VIEWS list" do
    it "returns 'iterations'" do
      ["foo", "baz", "bar"].each do |view|
        StoriesIndexPresenter.new(:view => view).view.should == 'iterations'
      end
    end
  end
end

describe StoriesIndexPresenter, '#iterations?' do
  it "returns true when #view returns 'iterations'" do
    StoriesIndexPresenter.new(:view => 'iterations').iterations?.should be_true
  end
  
  it "returns false otherwise" do
    StoriesIndexPresenter.new(:view => 'tags').iterations?.should be_false    
  end
end

describe StoriesIndexPresenter, '#tags?' do
  it "returns true when #view returns 'tags'" do
    StoriesIndexPresenter.new(:view => 'tags').tags?.should be_true
  end
  
  it "returns false otherwise" do
    StoriesIndexPresenter.new(:view => 'iterations').tags?.should be_false    
  end
end

describe StoriesIndexPresenter, '#iterations_presenter' do
  before do
    @project = stub("project", 
      :iterations_ordered_by_start_date => nil, 
      :backlog_iteration => nil)
    @presenter = StoriesIndexPresenter.new :project => @project
    IterationsPresenter.stub!(:new)
  end
  
  it "finds all iterations ordered by start date" do
    @project.should_receive(:iterations_ordered_by_start_date)
    @presenter.iterations_presenter
  end
  
  it "finds the backlog iteration" do
    @project.should_receive(:backlog_iteration)
    @presenter.iterations_presenter
  end
  
  it "creates a new IterationsPresenter" do
    iterations, backlog_iteration = stub("iterations"), stub("backlog_iterations")
    @project.stub!(:iterations_ordered_by_start_date).and_return(iterations)
    @project.stub!(:backlog_iteration).and_return(backlog_iteration)
    IterationsPresenter.should_receive(:new).with(
      :iterations => iterations, 
      :backlog => backlog_iteration,
      :project => @project)
    @presenter.iterations_presenter
  end
  
  it "returns the newly created iterations_presenter" do
    iterations_presenter = stub("iterations presenter")
    IterationsPresenter.stub!(:new).and_return(iterations_presenter)
    @presenter.iterations_presenter.should == iterations_presenter
  end
  
  it "caches the return value for subsequent calls" do
    IterationsPresenter.should_receive(:new).once.and_return(:foo)
    @presenter.iterations_presenter.should == :foo
    @presenter.iterations_presenter.should == :foo # only the call is executed, this one is cached
  end
end
