require 'fileutils'

plugin_spec_directory = File.expand_path(File.dirname(__FILE__))

# Lets load up a rails environment
# unless defined?(RAILS_ROOT)
#  RAILS_ROOT = ENV["RAILS_ROOT"] || File.join(plugin_spec_directory, "../../../..")
# end
# require File.join(RAILS_ROOT, "spec", "spec_helper")
$:.unshift File.join(plugin_spec_directory, "../../../../vendor/rails")
require 'action_controller'
require 'active_record'
require 'action_mailer'
require File.join(plugin_spec_directory, "../init")

# Setup up routes for our tests
ActionController::Routing::Routes.clear!
ActionController::Routing::Routes.draw {|m| m.connect ':controller/:action/:id' }
ActionController::Routing.use_controllers! %w(users account admin/users)

# Setup logging and db connection
FileUtils.mkdir( File.join( plugin_spec_directory, 'tmp' ) ) unless File.exists?( File.join( plugin_spec_directory, 'tmp' ) )
ActiveRecord::Base.logger = Logger.new File.join( plugin_spec_directory, 'tmp/test.log' )
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => File.join( plugin_spec_directory, 'tmp/test.db' )

# Load schema
ActiveRecord::Schema.suppress_messages do
  ActiveRecord::Schema.define do
    create_table :default_active_record_models, :force => true do |t|
    end
    
    create_table :lwt_authentication_system_models, :force => true do |t|
      t.column :password_hash, :string
      t.column :salt, :string
      t.column :email_address, :string
      t.column :group_id, :integer
      t.column :active, :boolean
      t.column :remember_me_token, :string
      t.column :remember_me_token_expires_at, :datetime
    end
    
    create_table :groups, :force => true do |t|
      t.column :name, :string
    end
    
    create_table :privileges, :force => true do |t|
      t.column :name, :string
    end
    
    create_table :groups_privileges, :force => true do |t|
      t.column :group_id, :integer
      t.column :privilege_id, :integer
    end
    # 
    # create_table :users, :force => true do |t|
    #   t.column :username, :string
    #   t.column :password_hash, :string
    #   t.column :group_id, :integer
    #   t.column :email_address, :string
    #   t.column :active, :boolean
    # end
    #   
    # create_table :user_reminders, :force => true do |t|
    #   t.column :user_id, :integer
    #   t.column :token, :string
    #   t.column :expires_at, :datetime
    # end    
  end
end

# ActiveRecord models
class DefaultActiveRecordModel < ActiveRecord::Base
end

class LWTAuthenticationSystemModel < ActiveRecord::Base
  acts_as_login_model
end


# class UsersController < ActionController::Base
# end
# 
# class AccountController < ActionController::Base
# end
# 
# module Admin
#   class UsersController < ActionController::Base
#   end
# end


