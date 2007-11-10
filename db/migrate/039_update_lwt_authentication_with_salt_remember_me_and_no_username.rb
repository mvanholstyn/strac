class UpdateLwtAuthenticationWithSaltRememberMeAndNoUsername < ActiveRecord::Migration
  class User < ActiveRecord::Base ; end
  
  def self.up
    add_column :users, :salt, :string
    add_column :users, :remember_me_token, :string
    add_column :users, :remember_me_token_expires_at, :datetime
    remove_column :users, :username
    
    # make sure the admin account is active
    user = User.find_by_email_address("admin@example.com")
    user.active = true
    user.save
  end

  def self.down
    remove_column :users, :salt
    remove_column :users, :remember_me_token
    remove_column :users, :remember_me_token_expires_at
    add_column :users, :username, :string
  end
end
