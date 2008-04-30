class Spec::Rails::Example::ControllerExampleGroup
  include ActionController::UrlWriter
  
  def stub_login_for(controller_klass)
    @user = mock_model(User)
    @project ||= mock_model(Project, :id => 91)

    controller.stub!(:current_user).and_return(@user)
    controller_klass.login_model.stub!(:find).and_return(@user)
    @user.stub!(:has_privilege?).and_return(true)
    @user
  end
  
  def login_as(user)
    stub_login_for controller_class
  end 

  def old_login_as(user)
    if user.is_a?(String) || user.is_a?(Symbol)
      user = users(user)
    end
    @request.session[:current_user_id] = user.id
    User.current_user = user
  end
  
  def self.it_does_not_require_login(method, action)
    it_skips_before_filter(:login_required, action)
  end  
  
  def self.it_requires_login(method, action, params={})
    describe controller_class, "#{method} ##{action} requires login" do
      before do
        stub_before_filters! :except => :login_required
      end
      
      describe controller_class, "when not logged in" do
        it "redirects to signup" do
          send method, action, params
          response.should redirect_to(login_path)
        end
    
        it "does not call the action" do
          controller.should_not_receive(action)
          send method, action, params
        end
      end
  
      describe controller_class, "when logged in" do
        before do
          stub_login_for controller_class
        end
        
        it "calls the action" do
          controller.should_receive(action)
          send method, action, params
        end
      end
    end
  end
  
  def self.it_requires_a_superuser(method, action, params={})
    describe controller_class, "#{method} ##{action} requires a superuser to be logged in" do
      before do
        stub_before_filters! :except => :superuser_required
      end
      
      describe controller_class, "when a user is not logged in" do
        it "redirects the user to the signup page" do
          send method, action, params
          response.should redirect_to(signup_path)
        end
    
        it "sets an error message telling them that they need to log in or sign up" do
          send method, action, params
          flash[:error].should == "You need to sign up or log in before you can do that."
        end
      end 

      describe controller_class, "when a user is logged in but is not a superuser" do
        before do
          login_with_user
        end
    
        it "sets an error message telling the user they don't have access" do
          send method, action, params
          flash[:error].should =~ /You don't have access to/i
        end
    
        describe controller_class, "when a user came from a referring page" do
          before do
            @referer = "http://www.google.com"
            request.headers["HTTP_REFERER"] = @referer
          end
      
          it "redirects the user :back to the referring page" do
            send method, action, params
            response.should redirect_to(@referer)
          end
        end
    
        describe controller_class, "when a user did not come from a referring page" do
          before do
            request.headers["HTTP_REFERER"] = nil
          end

          it "redirects the user to their home page" do
            send method, action, params
            response.should redirect_to(home_path)
          end
        end
      end
      
      describe controller_class, "when a superuser is logged in" do
        before do
          user = login_with_user
          user.stub!(:superuser?).and_return(true)
        end
        
        it "calls the action" do
          controller.should_receive(action)
          send method, action, params
        end
      end
    end
  end
  
end
