class UpdateLwtAuthenticationWithSaltRememberMeAndNoUsername < ActiveRecord::Migration
  def self.up
    add_column :users, :salt, :string
    add_column :users, :remember_me_token, :string
    add_column :users, :remember_me_token_expires_at, :datetime
    remove_column :users, :username
  end

  def self.down
    remove_column :users, :salt
    remove_column :users, :remember_me_token
    remove_column :users, :remember_me_token_expires_at
    ad_column :users, :username, :string
  end
end
