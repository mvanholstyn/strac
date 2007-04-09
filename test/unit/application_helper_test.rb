require File.dirname(__FILE__) + '/../test_helper'
  
class ApplicationHelperTest < Test::Unit::TestCase
  
  class ViewMock < ActionView::Base
    include ApplicationHelper

    def initialize
      @controller = ApplicationController.new  
      @request    = ActionController::TestRequest.new 
      @response   = ActionController::TestResponse.new
      
      @controller.process @request, @response
    end
  end
  
  def setup
    @view_mock = ViewMock.new
  end
  
  def test_story_id_should_not_convert_into_hyperlink_with_nonexistant_story
    Story.expects( :find_by_id ).with('1').returns(nil)

    description = @view_mock.expand_ids( "A link for S1." ) 

    url = @view_mock.send( :story_path, :project_id=>1, :id=>1 )
    link = @view_mock.send( :link_to, "S1", url )
    assert_equal "A link for S1.", description
  end
  
  def test_story_id_should_convert_into_hyperlink
    story_mock = mock( :id=>1, :name=>"Story Uno", :project_id=>1 )
    Story.expects( :find_by_id ).with('1').returns(story_mock)

    description = @view_mock.expand_ids( "A link for S1." ) 

    url = @view_mock.send( :story_path, :project_id=>1, :id=>1 )
    link = @view_mock.send( :link_to, "Story Uno", url )
    assert_equal "A link for #{link}.", description
  end
  
  def test_story_id_at_the_beginning_of_string_should_convert_into_hyperlink
    story_mock = mock( :id=>1, :name=>"Story Uno", :project_id=>1 )
    Story.expects( :find_by_id ).with('1').returns(story_mock)

    description = @view_mock.expand_ids( "S1 is here." ) 

    url = @view_mock.send( :story_path, :project_id=>1, :id=>1 )
    link = @view_mock.send( :link_to, "Story Uno", url )
    assert_equal "#{link} is here.", description
  end
  
  def test_story_id_at_the_end_of_string_should_convert_into_hyperlink
    story_mock = mock( :id=>1, :name=>"Story Uno", :project_id=>1 )
    Story.expects( :find_by_id ).with('1').returns(story_mock)

    description = @view_mock.expand_ids( "Story at the end S1" ) 

    url = @view_mock.send( :story_path, :project_id=>1, :id=>1 )
    link = @view_mock.send( :link_to, "Story Uno", url )
    assert_equal "Story at the end #{link}", description
  end
  
  def test_story_id_in_the_middle_of_a_word_should_not_convert_into_hyperlink
    description = @view_mock.expand_ids( "A speS1ial story" ) 
    assert_equal "A speS1ial story", description
  end
  
  def test_story_ids_across_newlines_should_convert_into_hyperlink
    story_mock1 = mock( :id=>1, :name=>"Story Uno", :project_id=>1 )
    story_mock2 = mock( :id=>2, :name=>"Story Dos", :project_id=>1 )
    story_mock3 = mock( :id=>3, :name=>"Story Tres", :project_id=>1 )
    
    Story.expects( :find_by_id ).with('1').returns(story_mock1)
    Story.expects( :find_by_id ).with('2').returns(story_mock2)
    Story.expects( :find_by_id ).with('3').returns(story_mock3)

    description = @view_mock.expand_ids( "Line 1 S1\n Line 2 S2...\nLine 3 S3!" ) 

    url1 = @view_mock.send( :story_path, :project_id=>1, :id=>1 )
    link1 = @view_mock.send( :link_to, "Story Uno", url1 )
    
    url2 = @view_mock.send( :story_path, :project_id=>1, :id=>2 )
    link2 = @view_mock.send( :link_to, "Story Dos", url2 )
    
    url3 = @view_mock.send( :story_path, :project_id=>1, :id=>3 )
    link3 = @view_mock.send( :link_to, "Story Tres", url3 )

    expected_link = "Line 1 #{link1}\n Line 2 #{link2}...\nLine 3 #{link3}!"
    assert_equal expected_link, description
  end
  
  
end