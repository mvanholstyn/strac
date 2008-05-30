require File.dirname(__FILE__) + '/../spec_helper'

describe IterationsPresenter, "#backlog" do
  it "returns a backlog iteration presenter wrapping the passed in backlog" do
    @backlog = mock "backlog iteration"
    @project = mock "project", :iterations => mock("iterations", :backlog => @backlog)
    backlog_presenter = mock "backlog presenter"
    BacklogIterationPresenter.should_receive(:new).with(@backlog, []).and_return(backlog_presenter)
    @iterations_presenter = IterationsPresenter.new :stories=>[], :project => @project
    @iterations_presenter.backlog.should == backlog_presenter
  end
end


describe IterationsPresenter, "#project" do
  before do
    @project = mock "project"
    @iterations_presenter = IterationsPresenter.new :stories=>[], :project => @project
  end

  it "returns the passed in backlog" do
    @iterations_presenter.project.should == @project
  end
end

describe IterationsPresenter, "Enumerable functionality" do
  before do
    @backlog = "backlog iteration"
    @iterations = [ mock("iteration1"), mock("iteration2") ]
    @stories = [ mock("story1", :bucket => @iterations[0]), mock("story2", :bucket => @iterations[1]) ]
    @iterations_presenter = IterationsPresenter.new :stories => @stories
  end
  
  it "includes Enumerable" do
    IterationsPresenter.ancestors.should include(Enumerable)
  end
  
  it "iterates over only the passed in iterations with #each" do
    wrapped_iterations = [ mock("iteration presenter 1", :started_at => 10.days.ago), mock("iteration presenter 2", :started_at => 5.days.ago) ]
    IterationPresenter.should_receive(:new).with(@iterations.first, [@stories.first]).and_return(wrapped_iterations.first)
    IterationPresenter.should_receive(:new).with(@iterations.last, [@stories.last]).and_return(wrapped_iterations.last)
    @iterations_presenter.each do |iter|
      iter.should == wrapped_iterations.shift
    end
  end
end