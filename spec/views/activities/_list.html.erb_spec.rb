require File.dirname(__FILE__) + '/../../spec_helper'

describe "/activities/_list.html.erb with a project that has an activity" do
  
  before do
    @project1 = mock_model(Project)
    
    @project1.stub!(:name).and_return("Project 1")
    @project1.stub!(:id).and_return(1)
        
    @activity1 = mock "activity 1"
    @activity1.stub!(:action).and_return("action1")
    
    @activity2 = mock "activity 2"
    @activity2.stub!(:action).and_return("action2")

    @activity1.should_receive(:created_at).and_return(Time.now)
    @activity1.should_receive(:actor).and_return(OpenStruct.new(:full_name=>"Davy Jones"))
    template.should_receive(:expand_ids).with("action1").and_return "Expanded IDs"

    @activity2.should_receive(:created_at).and_return(Time.now)
    @activity2.should_receive(:actor).and_return(OpenStruct.new(:full_name=>"Davy Jones"))
    template.should_receive(:expand_ids).with("action2").and_return "Expanded IDs"

    @activities = [ @activity1, @activity2 ]    
    render :partial => "/activities/list.html.erb", :locals => {:activities=>@activities}
  end

  it "creates an activity row for each activity" do
    response.should have_tag("tr.activity") do
      with_tag ".created-at"
      with_tag ".activator"
      with_tag ".action"
    end
  end
  
  it "does not display a 'No recent items' message" do
    response.should_not have_tag("td i", /No recent items/)
  end

end
