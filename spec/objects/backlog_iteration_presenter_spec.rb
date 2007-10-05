require File.dirname(__FILE__) + '/../spec_helper'

describe BacklogIterationPresenter, "defaults" do
  before do
    @iteration = mock "iteration"
    @backlog = BacklogIterationPresenter.new @iteration
  end

  it "delegates #project to the passed in iteration" do
    @project = mock "start date"
    @iteration.should_receive(:project).and_return(@project)
    @backlog.project.should == @project
  end
end

describe BacklogIterationPresenter, "#stories" do
  before do
    @iteration = mock "iteration"
    @backlog = BacklogIterationPresenter.new @iteration
  end

  it "returns the project's backlog stories" do
    stories = mock "stories"
    @iteration.should_receive(:stories).and_return(stories)
    @backlog.stories.should == stories
  end
end

describe BacklogIterationPresenter, "#unique_id" do
  before do
    @iteration = mock "iteration"
    @backlog = BacklogIterationPresenter.new @iteration
  end

  it "returns 'iteration_nil'" do
    @backlog.unique_id.should == 'iteration_nil'
  end
end
