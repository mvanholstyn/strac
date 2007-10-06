require File.dirname(__FILE__) + '/../spec_helper'

describe IterationsPresenter, "#iterations" do
  before do
    @iterations = [ mock("iteration1"), mock("iteration2") ]
    @iterations_presenter = IterationsPresenter.new :iterations => @iterations    
  end

  it "returns a list of the passed in iterations wrapped in individual IterationPresenter's" do
    wrapped_iterations = [ mock("iteration presenter 1"), mock("iteration presenter 2") ]
    IterationPresenter.should_receive(:new).with(@iterations.first).and_return(wrapped_iterations.first)
    IterationPresenter.should_receive(:new).with(@iterations.last).and_return(wrapped_iterations.last)
    @iterations_presenter.iterations.should == wrapped_iterations
  end
end

describe IterationsPresenter, "#backlog" do
  it "returns a backlog iteration presenter wrapping the passed in backlog" do
    @backlog = mock "backlog iteration"
    backlog_presenter = mock "backlog presenter"
    BacklogIterationPresenter.should_receive(:new).with(@backlog).and_return(backlog_presenter)
    @iterations_presenter = IterationsPresenter.new :iterations=>[], :backlog => @backlog
    @iterations_presenter.backlog.should == backlog_presenter
  end

  it "returns nil when the passed in backlog is nil" do
    @iterations_presenter = IterationsPresenter.new :iterations=>[], :backlog => nil
    @iterations_presenter.backlog.should be_nil
  end
end


describe IterationsPresenter, "#project" do
  before do
    @project = mock "project"
    @iterations_presenter = IterationsPresenter.new :iterations=>[], :project => @project
  end

  it "returns the passed in backlog" do
    @iterations_presenter.project.should == @project
  end
end

describe IterationsPresenter, "containment_ids" do
  before do
    @backlog = mock("backlog")
    @backlog_presenter = mock("backlog presenter")
    @iterations = [mock("iteration")]
    @iterations_presenter = IterationsPresenter.new :iterations=>@iterations, :backlog => @backlog
  end
  
  it "returns each iteration's unique id including the backlog" do
    IterationPresenter.should_receive(:new).with(@iterations.first).and_return(@iterations.first)
    BacklogIterationPresenter.should_receive(:new).with(@backlog).and_return(@backlog_presenter)
    @backlog_presenter.should_receive(:unique_id).and_return("backlog_id")
    @iterations.first.should_receive(:unique_id).and_return("iteration_id")
    
    @iterations_presenter.containment_ids.should == ["backlog_id", "iteration_id"]
  end
end

describe IterationsPresenter, "Enumerable functionality" do
  before do
    @backlog = "backlog iteration"
    @iterations = [ mock("iteration1"), mock("iteration2") ]
    @iterations_presenter = IterationsPresenter.new :iterations => @iterations, :backlog => @backlog 
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

