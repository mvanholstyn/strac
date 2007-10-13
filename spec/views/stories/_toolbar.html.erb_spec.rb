require File.dirname(__FILE__) + '/../../spec_helper'

# TODO - need selenium tests for testing link to remotes
describe "/stories/_toolbar.html.erb" do
  before(:each) do
    project = stub "Project", :to_param => "42", :id => 42
    @story = stub( 
      "Story", 
      :id => 11,
      :comments => [ stub("comment1"), stub("comment2"), stub("comment3") ],
      :project => project, 
      :to_param => "11" )
      
    render :partial => "stories/toolbar", :locals => { :story => @story }
  end
  
  def in_the_toolbar(&blk)
    response.should have_tag(".toolbar") do
      yield if block_given?
    end
  end
  
  it "has a link for showing the story" do
    in_the_toolbar do
      response.should have_tag(".show[href=#][onclick*=?]", story_path(@story.project, @story))
    end
  end
  
  it "has a link for showing the story's comments" do
    in_the_toolbar do
      response.should have_tag(".comments[href=#][onclick*=?]", comments_url(@story.project, @story, :inline => true))
    end    
  end
  
  it "has a link for editing the story" do
    in_the_toolbar do
      response.should have_tag(".edit[href=#][onclick*=?]", edit_story_path(@story.project, @story))
    end    
  end
  
  it "has a link for logging time to the story" do
    in_the_toolbar do
      response.should have_tag(".time[href=#][onclick*=?]", time_story_path(@story.project, @story))
    end    
  end
  
  it "has a link for destroying the story" do
    in_the_toolbar do
      response.should have_tag(".destroy[href=#][onclick*=?]", story_path(@story.project, @story))
    end    
  end
  
  it "has a permalink for the story itself" do
    in_the_toolbar do
      response.should have_tag(".permalink[href=?]", story_path(@story.project, @story))
    end    
  end
end
