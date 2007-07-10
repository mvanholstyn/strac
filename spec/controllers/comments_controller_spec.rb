require File.dirname(__FILE__) + '/../spec_helper'

describe "User without the privilege user" do
  controller_name "comments"
  fixtures :users, :groups

  before(:each) do    
    @project_id = '1' 
    @story_id = '2'

    Story.should_receive(:find).with(@story_id)
    login_as 'user_without_privileges'
  end

  they "should be redirected to the dashboard when requesting index" do
    get :index, :story_id=>@story_id, :project_id=>@project_id
    response.should redirect_to(dashboard_path)
  end

  they "should be redirected to the dashboard when requesting new" do
    get :new, :story_id=>@story_id, :project_id=>@project_id
    response.should redirect_to(dashboard_path)
  end

  they "should be redirected to the dashboard controller when trying to post a comment" do
    post :create, :story_id=>@story_id, :project_id=>@project_id
    response.should redirect_to(dashboard_path)
  end

  they "should be redirected to the dashboard controller when trying to post a comment with xhr" do
    xhr :post, :create, :story_id=>@story_id, :project_id=>@project_id
    response.should redirect_to(dashboard_path)
  end
end


describe "CommentsController listing comments as a User with privilege user" do
  controller_name "comments"
  fixtures :users, :groups, :groups_privileges, :privileges
  
  before(:each) do    
    @project_id = '1' 
    @story_id = '2'
    
    story = mock "story"
    Story.should_receive(:find).with(@story_id).and_return(story)
    story.should_receive(:comments).and_return("comments")

    @user = login_as 'joe'
    @user.group.privileges.should include(privileges(:user))
  end

  it "should list comments" do
    get :index, :story_id=>@story_id, :project_id=>@project_id
    response.should be_success
    
    assigns[:comments].should == "comments"
    assigns[:is_rendering_inline_comments].should == false
  end
  
  it "should should list comments with is rendering popup comments as false" do
    get :index, :story_id=>@story_id, :project_id=>@project_id, :inline=>'false'
    response.should be_success
    
    assigns[:comments].should == "comments"
    assigns[:is_rendering_inline_comments].should == false
  end
  
  it "should should list comments inline" do
    get :index, :story_id=>@story_id, :project_id=>@project_id, :inline=>'true'
    response.should be_success
    
    assigns[:comments].should == "comments"
    assigns[:is_rendering_inline_comments].should == true
  end

end


describe "CommentsController creating comments as a User with privilege user" do
  controller_name "comments"
  fixtures :users, :groups, :groups_privileges, :privileges
  
  before(:each) do    
    @project_id = '1' 
    @story_id = '2'
    
    @story = mock "story"
    @comments = mock "comments"
    @comment = mock "comment"
    
    Story.should_receive(:find).with(@story_id).and_return(@story)
    @story.should_receive(:comments).and_return(@comments)

    @user = login_as 'joe'
  end
  
  it "should render new" do
    @comments.should_receive(:build).and_return("comment")
    get :new, :story_id=>@story_id, :project_id=>@project_id
    response.should be_success
    assigns[:comment].should == "comment"
  end 

  it "should create a comment successfully" do
    comment_params = { 'content'=>'test comment', 'commenter_id'=>'1' }
    @comments.should_receive(:build).with(comment_params).and_return(@comment)
    @comment.should_receive(:commenter=).with(@user)
    @comment.should_receive(:save).and_return(true)
    
    xhr :post, :create, :comment => comment_params, :story_id=>@story_id, :project_id=>@project_id
    response.should be_success
    response.should render_template("create")
  end
  
  it "should fail to create a comment"
 
end
