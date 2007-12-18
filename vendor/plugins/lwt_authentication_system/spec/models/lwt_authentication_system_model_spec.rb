require File.join( File.dirname( __FILE__ ), '../spec_helper' )

describe LWTAuthenticationSystemModel, "responds to methods added by LWT::AuthenticationSystem::Model::ClassMethods" do
  it "responds to acts_as_login_model" do
    LWTAuthenticationSystemModel.should respond_to(:acts_as_login_model)
  end
end

describe LWTAuthenticationSystemModel, "responds to methods added by LWT::AuthenticationSystem::Model::SingletonMethods" do
  it "responds to current_user" do
    LWTAuthenticationSystemModel.should respond_to(:current_user)
  end
  
  it "responds to lwt_authentication_system_options" do
    LWTAuthenticationSystemModel.should respond_to(:lwt_authentication_system_options)
  end
  
  it "responds to login" do
    LWTAuthenticationSystemModel.should respond_to(:login)
  end
  
  it "responds to hash_password" do
    LWTAuthenticationSystemModel.should respond_to(:hash_password)
  end
end


describe LWTAuthenticationSystemModel, "instance responds to methods added by LWT::AuthenticationSystem::Model::InstanceMethods" do
  it "responds to group=" do
    LWTAuthenticationSystemModel.new.should respond_to(:group=)
  end

  it "responds to password" do
    LWTAuthenticationSystemModel.new.should respond_to(:password)
  end
  
  it "responds to password_confirmation" do
    LWTAuthenticationSystemModel.new.should respond_to(:password_confirmation)
  end

  it "responds to password=" do
    LWTAuthenticationSystemModel.new.should respond_to(:password=)
  end
  
  it "responds to password_confirmation=" do
    LWTAuthenticationSystemModel.new.should respond_to(:password_confirmation=)
  end
  
  it "responds to has_privilege?" do
    LWTAuthenticationSystemModel.new.should respond_to(:has_privilege?)
  end
  
  it "responds to remember_me!" do
    LWTAuthenticationSystemModel.new.should respond_to(:remember_me!)
  end
  
  it "responds to forget_me!" do
    LWTAuthenticationSystemModel.new.should respond_to(:forget_me!)
  end
end

describe LWTAuthenticationSystemModel, "responds to methods added by database schema" do
  
  it "responds to password_hash" do
    LWTAuthenticationSystemModel.new.should respond_to(:password_hash)
  end
  
  it "responds to group_id" do
    LWTAuthenticationSystemModel.new.should respond_to(:group_id)
  end
  
  it "responds to email_address" do
    LWTAuthenticationSystemModel.new.should respond_to(:email_address)
  end
  
  it "responds to active" do
    LWTAuthenticationSystemModel.new.should respond_to(:active)
  end
  
  it "responds to salt" do
    LWTAuthenticationSystemModel.new.should respond_to(:salt)
  end
  
  it "responds to remember_me_token" do
    LWTAuthenticationSystemModel.new.should respond_to(:remember_me_token)
  end
  
  it "responds to remember_me_token_expires_at" do
    LWTAuthenticationSystemModel.new.should respond_to(:remember_me_token_expires_at)
  end
end

describe LWTAuthenticationSystemModel, "acts_as_login_model" do
  it "acts_as_login_model"
end

describe LWTAuthenticationSystemModel, "hash_password" do
  it "hash_password returns SHA1 hash of password and salt" do
    LWTAuthenticationSystemModel.hash_password("password", "salt").should == "81c35bdfd7b6bc8878248ae59671c396aa519764"
  end
  
  it "hash_password sets hash_password method when passed a block" do
    original_hash_password_method = LWTAuthenticationSystemModel.lwt_authentication_system_options[:hash_password]
    LWTAuthenticationSystemModel.hash_password { |p| p }
    LWTAuthenticationSystemModel.lwt_authentication_system_options[:hash_password].should_not == original_hash_password_method
    LWTAuthenticationSystemModel.hash_password("password").should == "password"
    
    # Reset original hash_password method
    LWTAuthenticationSystemModel.hash_password &original_hash_password_method
  end
end

describe LWTAuthenticationSystemModel, "login" do
  before(:all) do
    @model = LWTAuthenticationSystemModel.new :email_address => "user@example.com", :password => "password", :password_confirmation => "password"
    @model.save_without_validation
  end
  
  it "with invalid email_address returns nil" do
    model = LWTAuthenticationSystemModel.login :email_address => "wrong_user@example.com", :password => "password"
    model.should be_nil
  end
  
  it "with invalid password returns nil" do
    model = LWTAuthenticationSystemModel.login :email_address => "user@example.com", :password => "wrong password"
    model.should be_nil
  end

  it "with valid email_address and password returns the model" do
    model = LWTAuthenticationSystemModel.login :email_address => "user@example.com", :password => "password"
    model.should == @model
  end
  
  it "with nil returns nil" do
    model = LWTAuthenticationSystemModel.login nil
    model.should be_nil
  end
  
  it "with empty hash returns nil" do
    model = LWTAuthenticationSystemModel.login({})
    model.should be_nil
  end
end

describe LWTAuthenticationSystemModel, "password/password_confirmation readers/writers" do
  before(:each) do
    @model = LWTAuthenticationSystemModel.new
  end
  
  it "password returns nil when @password is nil" do
    @model.instance_variable_set("@password", nil)
    @model.password.should be_nil
  end
  
  it "password returns nil when @password is not nil" do
    @model.instance_variable_set("@password", "some password")
    @model.password.should be_nil
  end
  
  it "password_confirmation returns nil when @password_confirmation is nil" do
    @model.instance_variable_set("@password_confirmation", nil)
    @model.password_confirmation.should be_nil
  end
  
  it "password_confirmation returns nil when @password_confirmation is not nil" do
    @model.instance_variable_set("@password_confirmation", "some password")
    @model.password_confirmation.should be_nil
  end
  
  it "password= sets @password to nil when value is blank" do
    [ nil, "" ].each do |value|
      @model.password = value
      @model.instance_variable_get("@password").should be_nil
    end
  end
  
  it "password= sets @password to value when value is not blank" do
    @model.password = "some password"
    @model.instance_variable_get("@password").should_not be_nil
  end
  
  it "password_confirmation= sets @password_confirmation to nil when value is blank" do
    [ nil, "" ].each do |value|
      @model.password_confirmation = value
      @model.instance_variable_get("@password_confirmation").should be_nil
    end
  end
  
  it "password_confirmation= sets @password_confirmation to value when value is not blank" do
    @model.password_confirmation = "some password"
    @model.instance_variable_get("@password_confirmation").should_not be_nil
  end
end

describe LWTAuthenticationSystemModel, "has_privilege?" do
  before(:each) do
    group = Group.create! :name => "admin"
    admin_privilege = Privilege.create! :name => "admin"
    super_admin_privilege = Privilege.create! :name => "super_admin"
    group.privileges << admin_privilege << super_admin_privilege 
    @model = LWTAuthenticationSystemModel.new :group => group
  end

  it "returns false if user does not have a group" do
    LWTAuthenticationSystemModel.new.has_privilege?(:admin).should be_false
  end

  it "returns false if user does not have the specified privilege" do
    @model.has_privilege?(:blogger).should be_false
  end

  it "returns false if user does not have any the specified privileges" do
    @model.has_privilege?(:blogger, :commenter).should be_false
  end

  it "returns true if user has the specified privilege" do
    @model.has_privilege?(:admin).should be_true
  end

  it "returns true if user has any of the specified privileges" do
    @model.has_privilege?(:admin, :blogger).should be_true
  end

  it "returns false if user does not have all of the specified privileges when match_all is true" do
    @model.has_privilege?(:admin, :blogger, :match_all => true).should be_false
  end

  it "returns true if user has all of the specified privileges when match_all is true" do
    @model.has_privilege?(:admin, :super_admin, :match_all => true).should be_true
  end
end