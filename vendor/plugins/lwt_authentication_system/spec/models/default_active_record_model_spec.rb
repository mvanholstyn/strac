require File.join(File.dirname( __FILE__ ), '../spec_helper')

describe DefaultActiveRecordModel, "responds to methods added by LWT::AuthenticationSystem::Model::ClassMethods" do
  it "responds to acts_as_login_model" do
    DefaultActiveRecordModel.should respond_to(:acts_as_login_model)
  end
end

describe DefaultActiveRecordModel, "does not respond to methods added by LWT::AuthenticationSystem::Model::SingletonMethods" do
  it "does not respond to current_user" do
    DefaultActiveRecordModel.should_not respond_to(:current_user)
  end
  
  it "does not respond to lwt_authentication_system_options" do
    DefaultActiveRecordModel.should_not respond_to(:lwt_authentication_system_options)
  end
  
  it "does not respond to login" do
    DefaultActiveRecordModel.should_not respond_to(:login)
  end
  
  it "does not respond to hash_password" do
    DefaultActiveRecordModel.should_not respond_to(:hash_password)
  end
end


describe DefaultActiveRecordModel, "instance does not respond to methods added by LWT::AuthenticationSystem::Model::InstanceMethods" do
  it "does not respond to group=" do
    DefaultActiveRecordModel.new.should_not respond_to(:group=)
  end

  it "does not respond to password" do
    DefaultActiveRecordModel.new.should_not respond_to(:password)
  end
  
  it "does not respond to password_confirmation" do
    DefaultActiveRecordModel.new.should_not respond_to(:password_confirmation)
  end

  it "does not respond to password=" do
    DefaultActiveRecordModel.new.should_not respond_to(:password=)
  end
  
  it "does not respond to password_confirmation=" do
    DefaultActiveRecordModel.new.should_not respond_to(:password_confirmation=)
  end
  
  it "does not respond to has_privilege?" do
    DefaultActiveRecordModel.new.should_not respond_to(:has_privilege?)
  end
  
  it "does not respond to remember_me!" do
    DefaultActiveRecordModel.new.should_not respond_to(:remember_me!)
  end
  
  it "does not respond to forget_me!" do
    DefaultActiveRecordModel.new.should_not respond_to(:forget_me!)
  end
end

describe DefaultActiveRecordModel, "does not respond to methods added by database schema" do
    
  it "does not respond to password_hash" do
    DefaultActiveRecordModel.new.should_not respond_to(:password_hash)
  end
  
  it "does not respond to group_id" do
    DefaultActiveRecordModel.new.should_not respond_to(:group_id)
  end
  
  it "does not respond to email_address" do
    DefaultActiveRecordModel.new.should_not respond_to(:email_address)
  end
  
  it "does not respond to active" do
    DefaultActiveRecordModel.new.should_not respond_to(:active)
  end
  
  it "does not respond to salt" do
    DefaultActiveRecordModel.new.should_not respond_to(:salt)
  end
  
  it "does not respond to remember_me_token" do
    DefaultActiveRecordModel.new.should_not respond_to(:remember_me_token)
  end
  
  it "does not respond to remember_me_token_expires_at" do
    DefaultActiveRecordModel.new.should_not respond_to(:remember_me_token_expires_at)
  end
end
