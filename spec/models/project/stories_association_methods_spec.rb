require File.dirname(__FILE__) + '/../../spec_helper'

describe Project, "#stories" do
  before do
    @project = Generate.project
    @old_completed_iteration = Generate.iteration :project => @project, :started_at => 2.weeks.ago, :ended_at => 1.week.ago
    @previous_iteration = Generate.iteration :project => @project, :started_at => 1.week.ago+1.minute, :ended_at => 1.day.ago
    @current_iteration = Generate.current_iteration :project => @project, :started_at => 1.day.ago+1.minute
    @story1 = Generate.story(:summary => "apples", :description => "granny smith", :bucket => @old_completed_iteration, :project => @project )
    @story2 = Generate.story(:summary => "more apples", :description => "Jonagold", :bucket => @previous_iteration, :project => @project)
    @story3 = Generate.story(:summary => "oranges", :description => "granny smith oranges", :bucket => @current_iteration, :project => @project)
    @story4 = Generate.story(:summary => "bananas", :description => "golden bananas", :bucket => nil, :project => @project)
  end
  
  it "can find all stories" do
    @project.stories.search(:text => "").should == [ @story1, @story2, @story3, @story4 ]
  end
  
  it "can find stories by summary" do
    @project.stories.search(:text => "apples").should == [ @story1, @story2 ]
  end
  
  it "can find stories by description" do
    @project.stories.search(:text => "granny").should == [ @story1, @story3 ]
  end
  
  it "can find stories by tags" do
    @story1.update_attribute :tag_list, "peaches"
    @story4.update_attribute :tag_list, "peaches, pears"
    @project.stories.search(:text => "peaches").should == [@story1, @story4]
  end

  it "can find recent stories (in the previous iteration, the current iteration or the backlog)" do
    stories = @project.stories.search(:text => "apples", :iteration => "recent")
    stories.should == [@story2]

    stories = @project.stories.search(:text => "granny", :iteration => "recent")
    stories.should == [@story3]

    stories = @project.stories.search(:text => "gold", :iteration => "recent")
    stories.should == [@story2, @story4]
  end
  
  it "is NOT prone to SQL injection via the :text parameter" do
    lambda {
      @project.stories.search(:text => "'")
    }.should_not raise_error
  end

  it "is NOT prone to SQL injection via the :recent parameter" do
    lambda {
      @project.stories.search(:iteration => "'")
    }.should_not raise_error
  end

end