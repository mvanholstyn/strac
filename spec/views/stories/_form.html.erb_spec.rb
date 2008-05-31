require File.dirname(__FILE__) + '/../../spec_helper'

describe "/stories/_form.html.erb" do
  def render_it
    assigns[:project] = @project
    assigns[:statuses] = @statuses
    assigns[:priorities] = @priorities
    form = ActionView::Helpers::FormBuilder.new "story", @story, template, Hash.new, nil
    render :partial => "stories/form", :locals => { :story => @story, :form => form  }
  end
  
  before do
    @user = mock_model(User, :full_name => "Zach Dennis")
    template.stub!(:current_user).and_return(@user)
    @story = mock_model(Story, 
      :bucket_id => 90,
      :description => nil,
      :points => 100,
      :possible_priorities => [],
      :possible_statuses => [],
      :priority_id => 105,
      :responsible_party_type_id => 110,
      :status_id => 120,
      :summary => nil, 
      :tag_list => nil
    )
    @users = stub("users", :find => [])
    @project = mock_model(Project, :buckets => [], :users => @users)
    @priorities = []
  end

  it "has a summary text field" do
    @story.stub!(:summary).and_return("SummaryFoo")
    render_it
    response.should have_text_field(:id => "story_summary", :value => "SummaryFoo")
  end

  it "has a preview checkbox" do
    render_it
    response.should have_check_box(:id => "story_#{@story.id}_description_preview_checkbox", :value => 1, :checked => true)
  end
  
  it "has a description text area" do
    @story.stub!(:description).and_return("abcdefghijk")
    render_it
    response.should have_text_area(:id => "story_#{@story.id}_description", :value => "abcdefghijk")
  end
  
  describe "when the story doesn't have an id" do
    it "has a tag list text field" do
      @story.stub!(:tag_list).and_return("apple, orange, banana")
      @story.stub!(:id).and_return(nil)
      render_it
      response.should have_text_field(:id => "story_nil_tag_list", :value => "apple, orange, banana")
    end
  end
  
  describe "when the story has have an id" do
    it "has a tag list text field for that story" do
      @story.stub!(:tag_list).and_return("apple, orange, banana")
      render_it
      response.should have_text_field(:id => "story_#{@story.id}_tag_list", :value => "apple, orange, banana")
    end
  end
  
  it "has a points text field" do
    @story.stub!(:points).and_return(75)
    render_it
    response.should have_text_field(:id => "story_points", :value => 75)
  end
  
  it "has a statuses dropdown select" do
    @story.stub!(:possible_statuses).and_return([
      mock_model(Status, :id => 1, :name => "Complete"),
      mock_model(Status, :id => 2, :name => "Not complete")
    ])
    render_it
    response.should have_tag('select#story_status_id') do
      with_tag('option[value=?]', 1, "Complete")
      with_tag('option[value=?]', 2, "Not complete")
    end
  end
  
  it "has a priorities dropdown select" do
    @story.stub!(:possible_priorities).and_return([
      mock_model(Priority, :id => 1, :name => "Urgent"),
      mock_model(Priority, :id => 2, :name => "Not urgent")      
    ])
    render_it
    response.should have_tag('select#story_priority_id') do
      with_tag('option[value=?]', 1, "Urgent")
      with_tag('option[value=?]', 2, "Not urgent")
    end
  end
  
  it "has a responsibility party dropdown select" do
    @story.stub!(:responsibility_party_type_id).and_return(2)
    template.stub!(:options_for_responsible_parties).and_return(%|
      <option value="1">John Hwang</option>
      <option value="2">Mark VanHolstyn</option>
    |)
    render_it
    response.should have_tag('select[name=?]', "story[responsible_party_type_id]") do
      with_tag('option[value=?]', 1, "John Hwang")
      with_tag('option[value=?]', 2, "Mark VanHolstyn")
    end
  end
  
  it "has a bucket dropdown select" do
    my_buckets = [
      mock_model(Bucket, :name => "Iteration 1", :type => "Iteration"), 
      mock_model(Bucket, :name => "Phase 1", :type => "Phase")
    ]
    @project.should_receive(:buckets).and_return(my_buckets)
    @story.stub!(:bucket_id).and_return(my_buckets.last.id)
    render_it
    response.should have_tag('select[name=?]', 'story[bucket_id]') do
      with_tag('optgroup[label=?]',"Iteration") do
        with_tag('option[value=?]', my_buckets.first.id, "Iteration 1")
      end
      with_tag('optgroup[label=?]',"Phase") do
        with_tag('option[value=?][selected=selected]', my_buckets.last.id, "Phase 1")
      end
    end
    
  end
    
  it "has an auto complete field for the tag list" do
    template.should_receive(:auto_complete_field).with(
      "story_#{@story.id}_tag_list",
      :url => auto_complete_tags_path, 
      :tokens => ",", 
      :param_name => 'tag', 
      :method => "get"
    ).and_return(%|<p id="tag-list-auto-complete" />|)
    render_it
    response.should have_tag('p#tag-list-auto-complete')
  end
  
  it "observes the description field" do
    template.should_receive(:observe_field).with(
      "story_#{@story.id}_description",
      :url => textile_preview_path,
      :update => "story_#{@story.id}_description_preview",
      :with => "'textile=' + encodeURIComponent( value )",
      :frequency => 5,
      :condition => "$('story_#{@story.id}_description_preview_checkbox').checked"
    ).and_return(%|<p id="description-observer" />|)
    render_it
    response.should have_tag('p#description-observer')
  end

end
