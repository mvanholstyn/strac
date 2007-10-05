require File.dirname(__FILE__) + '/../spec_helper'

describe IterationsPresenter, "#iterations" do
  before do
    @iterations = [ mock("iteration1"), mock("iteration2") ]
    @iterations_presenter = IterationsPresenter.new @iterations    
  end

  it "returns a list of the passed in iterations wrapped in individual IterationPresenter's" do
    wrapped_iterations = [ mock("iteration presenter 1"), mock("iteration presenter 2") ]
    IterationPresenter.should_receive(:new).with(@iterations.first).and_return(wrapped_iterations.first)
    IterationPresenter.should_receive(:new).with(@iterations.last).and_return(wrapped_iterations.last)
    @iterations_presenter.iterations.should == wrapped_iterations
  end
end

describe IterationsPresenter, "#backlog" do
  before do
    @backlog = mock "backlog iteration"
    @iterations_presenter = IterationsPresenter.new [], @backlog
  end

  it "returns the passed in backlog" do
    backlog_presenter = mock "backlog presenter"
    BacklogIterationPresenter.should_receive(:new).with(@backlog).and_return(backlog_presenter)
    @iterations_presenter.backlog.should == backlog_presenter
  end
end

describe IterationsPresenter, "Enumerable functionality" do
  before do
    @iterations = [ mock("iteration1"), mock("iteration2") ]
    @iterations_presenter = IterationsPresenter.new @iterations    
  end
  
  it "includes Enumerable" do
    IterationsPresenter.ancestors.should include(Enumerable)
  end
  
  it "iterates over only the passed in iterations with #each" do
    wrapped_iterations = [ mock("iteration presenter 1"), mock("iteration presenter 2") ]
    IterationPresenter.should_receive(:new).with(@iterations.first).and_return(wrapped_iterations.first)
    IterationPresenter.should_receive(:new).with(@iterations.last).and_return(wrapped_iterations.last)
    @iterations_presenter.each do |iter|
      iter.should == wrapped_iterations.shift
    end
  end
  
  it "iterates over the backlog iteration plus the passed in iterations with #each_with_backlog" do
    backlog_presenter = mock "backlog presenter"
    BacklogIterationPresenter.should_receive(:new).with(@backlog).and_return(backlog_presenter)

    wrapped_iterations = [ mock("iteration presenter 1"), mock("iteration presenter 2") ]
    IterationPresenter.should_receive(:new).with(@iterations.first).and_return(wrapped_iterations.first)
    IterationPresenter.should_receive(:new).with(@iterations.last).and_return(wrapped_iterations.last)

    expected_iterations = [backlog_presenter] + wrapped_iterations
    @iterations_presenter.each_with_backlog do |iter|
      iter.should == expected_iterations.shift
    end
  end
end

