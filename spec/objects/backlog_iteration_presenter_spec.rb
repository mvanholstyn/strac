require File.dirname(__FILE__) + '/../spec_helper'

def build_backlog_iteration
  @iteration = mock "iteration"
  @backlog = BacklogIterationPresenter.new @iteration
end

describe BacklogIterationPresenter, "defaults" do
  before do
    build_backlog_iteration
  end

  it "delegates #project to the passed in iteration" do
    @project = mock "start date"
    @iteration.should_receive(:project).and_return(@project)
    @backlog.project.should == @project
  end
  
  it "returns 'backlog' for #id" do
    @backlog.id.should == "backlog"
  end
end

describe BacklogIterationPresenter, "#stories" do
  before do
    build_backlog_iteration
  end

  it "returns the project's backlog stories" do
    project = mock "project"
    stories = mock "stories"
    @iteration.should_receive(:project).and_return(project)
    project.should_receive(:backlog_stories).and_return(stories)
    @backlog.stories.should == stories
  end
end

describe BacklogIterationPresenter, "#unique_id" do
  before do
    build_backlog_iteration
  end

  it "returns 'iteration_nil'" do
    @backlog.unique_id.should == 'iteration_nil'
  end
end

describe BacklogIterationPresenter, "#show?" do
  before do
    build_backlog_iteration
  end

  it "returns 'false'" do
    @backlog.show?.should == false
  end
end
