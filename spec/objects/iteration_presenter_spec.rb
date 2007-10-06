require File.dirname(__FILE__) + '/../spec_helper'

def build_iteration_presenter
  @iteration = mock("iteration1")
  @iteration_presenter = IterationPresenter.new @iteration  
end

describe IterationPresenter, "#unique_id" do
  before do
    build_iteration_presenter
  end

  it "returns a unique string identifer for the passed in iteration using it's numeric id when it is not a new record" do
    @iteration.should_receive(:new_record?).and_return(false)
    @iteration.should_receive(:id).and_return(100)
    @iteration_presenter.unique_id.should == "iteration_100"
  end

  it "returns a unique string identifer for the passed in iteration using the string 'nil' when it is a new record" do
    @iteration.should_receive(:new_record?).and_return(true)
    @iteration_presenter.unique_id.should == "iteration_nil"
  end
end

describe IterationPresenter, "#show?" do
  it "returns true when the iteration's end date is greater then or equal to today's dates" do
    build_iteration_presenter
    
    @iteration.should_receive(:end_date).and_return(Date.today)
    @iteration_presenter.should be_show

    build_iteration_presenter
    @iteration.should_receive(:end_date).and_return(Date.today+1.week)
    @iteration_presenter.should be_show

    build_iteration_presenter
    @iteration.should_receive(:end_date).and_return(Date.today+1.year)
    @iteration_presenter.should be_show
  end
  
  it "returns false when the iteratin's end date is less then today's date" do
    build_iteration_presenter
    @iteration.stub!(:stories).and_return([])
    @iteration.should_receive(:end_date).and_return(Date.today-1)
    @iteration_presenter.should_not be_show

    build_iteration_presenter
    @iteration.stub!(:stories).and_return([])
    @iteration.should_receive(:end_date).and_return(Date.today-1.week)
    @iteration_presenter.should_not be_show

    build_iteration_presenter
    @iteration.stub!(:stories).and_return([])
    @iteration.should_receive(:end_date).and_return(Date.today-1.year)
    @iteration_presenter.should_not be_show
  end
  
  it "returns false when the iteratin's end date is less then today's date and all stories are complete?" do
    build_iteration_presenter
    @iteration.stub!(:stories).and_return([stub("story", :incomplete? => false)])
    @iteration.should_receive(:end_date).and_return(Date.today-1)
    @iteration_presenter.should_not be_show
  end
  
  it "returns true when the iteratin's end date is less then today's date and a story is incomplete?" do
    build_iteration_presenter
    @iteration.stub!(:stories).and_return([stub("story", :incomplete? => true)])
    @iteration.should_receive(:end_date).and_return(Date.today-1)
    @iteration_presenter.should be_show
  end
end

describe IterationPresenter, "defaults" do
  before do
    build_iteration_presenter
  end

  it "delegates #id to the passed in iteration" do
    @id = mock "id"
    @iteration.should_receive(:id).and_return(@id)
    @iteration_presenter.id.should == @id
  end

  it "delegates #start_date to the passed in iteration" do
    @start_date = mock "start date"
    @iteration.should_receive(:start_date).and_return(@start_date)
    @iteration_presenter.start_date.should == @start_date
  end

  it "delegates #end_date to the passed in iteration" do
    @end_date = mock "end date"
    @iteration.should_receive(:end_date).and_return(@end_date)
    @iteration_presenter.end_date.should == @end_date
  end

  it "delegates #project to the passed in iteration" do
    @project = mock "project"
    @iteration.should_receive(:project).and_return(@project)
    @iteration_presenter.project.should == @project
  end
  
  it "delegates #name to the passed in iteration" do
    @name = mock "name"
    @iteration.should_receive(:name).and_return(@name)
    @iteration_presenter.name.should == @name
  end

  it "delegates #budget to the passed in iteration" do
    @budget = mock "budget"
    @iteration.should_receive(:budget).and_return(@budget)
    @iteration_presenter.budget.should == @budget
  end

  it "delegates #points_completed to the passed in iteration" do
    @points_completed = mock "start date"
    @iteration.should_receive(:points_completed).and_return(@points_completed)
    @iteration_presenter.points_completed.should == @points_completed
  end
  
  it "delegates #points_remaining to the passed in iteration" do
    @points_remaining = mock "points remaining"
    @iteration.should_receive(:points_remaining).and_return(@points_remaining)
    @iteration_presenter.points_remaining.should == @points_remaining
  end

  it "delegates #display_name to the passed in iteration" do
    @display_name = mock "display name"
    @iteration.should_receive(:display_name).and_return(@display_name)
    @iteration_presenter.display_name.should == @display_name
  end

  it "delegates #stories to the passed in iteration" do
    @stories = mock "stories"
    @iteration.should_receive(:stories).and_return(@stories)
    @iteration_presenter.stories.should == @stories
  end

end
