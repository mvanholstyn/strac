require File.dirname(__FILE__) + '/../spec_helper'

def build_backlog_iteration
  @iteration = mock "iteration"
  @stories = []
  @backlog = BacklogIterationPresenter.new @iteration, @stories
end

describe BacklogIterationPresenter, "defaults" do
  before do
    build_backlog_iteration
  end

  it "delegates #project to the passed in iteration" do
    @project = mock "project"
    @iteration.should_receive(:project).and_return(@project)
    @backlog.project.should == @project
  end

  it "delegates #name to the passed in iteration" do
    @name = mock "name"
    @iteration.should_receive(:name).and_return(@name)
    @backlog.name.should == @name
  end
  
  it "returns 'backlog' for #id" do
    @backlog.id.should == "backlog"
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
