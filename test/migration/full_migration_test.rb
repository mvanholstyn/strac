require File.expand_path(File.dirname(__FILE__) + '/../test_helper') 

#
# This excercises the full set of migrations for your Rails app.
# It proves:
#   - After full migration, the database is in the expected state, including:
#     - All table structure
#     - Default data (if any)
#   - Full downward (version 0) migration functions correctly.
#
# YOU NEED TO:
#   - Update "see_full_schema"
#   - Update "see_data"
# 
class FullMigrationTest < ActionController::IntegrationTest

  # 
  # Transactional fixtures can, on occasion, cause migration tests to hang.
  # Applying this setting here will turn transactional fixtures off for THIS
  # SUITE ONLY
  #
  # self.use_transactional_fixtures = false

  def conn
    ActiveRecord::Base.connection
  end

  def see_empty_schema
    assert_schema do |s|

    end
  end

  #
  # Structure and Content assertions
  #

  # Fully assert db structure after full migration
  def see_full_schema
    assert_schema do |s|
      s.table "activities" do |t|
        t.column "id", :integer
        t.column "actor_id", :integer
        t.column "action", :string
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
        t.column "project_id", :integer
        t.column "affected_id", :integer
        t.column "affected_type", :string
      end

      s.table "comments" do |t|
        t.column "id", :integer
        t.column "content", :text
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
        t.column "commenter_id", :integer
        t.column "commentable_id", :integer
        t.column "commentable_type", :string
      end

      s.table "companies" do |t|
        t.column "id", :integer
        t.column "name", :string
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
      end

      s.table "groups" do |t|
        t.column "id", :integer
        t.column "name", :string
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
      end

      s.table "groups_privileges" do |t|
        t.column "id", :integer
        t.column "group_id", :integer
        t.column "privilege_id", :integer
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
      end

      s.table "invitations" do |t|
        t.column "id", :integer
        t.column "inviter_id", :integer
        t.column "recipient", :string
        t.column "project_id", :integer
        t.column "code", :string
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
      end

      s.table "iterations" do |t|
        t.column "id", :integer
        t.column "start_date", :date
        t.column "end_date", :date
        t.column "project_id", :integer
        t.column "name", :string
        t.column "budget", :integer
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
      end

      s.table "logged_exceptions" do |t|
        t.column "id", :integer
        t.column "exception_class", :string
        t.column "controller_name", :string
        t.column "action_name", :string
        t.column "message", :text
        t.column "backtrace", :text
        t.column "environment", :text
        t.column "request", :text
        t.column "created_at", :datetime
      end

      s.table "priorities" do |t|
        t.column "id", :integer
        t.column "name", :string
        t.column "color", :string
        t.column "position", :integer
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
      end

      s.table "privileges" do |t|
        t.column "id", :integer
        t.column "name", :string
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
      end

      s.table "project_permissions" do |t|
        t.column "id", :integer
        t.column "project_id", :integer
        t.column "accessor_id", :integer
        t.column "accessor_type", :string
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
      end

      s.table "projects" do |t|
        t.column "id", :integer
        t.column "name", :string
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
      end

      s.table "statuses" do |t|
        t.column "id", :integer
        t.column "name", :string
        t.column "color", :string
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
      end

      s.table "stories" do |t|
        t.column "id", :integer
        t.column "summary", :string
        t.column "description", :text
        t.column "points", :integer
        t.column "position", :integer
        t.column "iteration_id", :integer
        t.column "project_id", :integer
        t.column "responsible_party_id", :integer
        t.column "responsible_party_type", :string
        t.column "status_id", :integer
        t.column "priority_id", :integer
        t.column "created_at", :datetime
        t.column "completed_at", :datetime
        t.column "updated_at", :datetime
      end

      s.table "taggings" do |t|
        t.column "id", :integer
        t.column "tag_id", :integer
        t.column "taggable_id", :integer
        t.column "taggable_type", :string
      end

      s.table "tags" do |t|
        t.column "id", :integer
        t.column "name", :string
      end

      s.table "time_entries" do |t|
        t.column "id", :integer
        t.column "hours", :decimal
        t.column "comment", :string
        t.column "date", :date
        t.column "project_id", :integer
        t.column "timeable_id", :integer
        t.column "timeable_type", :string
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
      end
      
      s.table :user_reminders do |t|
        t.column :id, :integer
        t.column :user_id, :integer
        t.column :token, :string
        t.column :expires_at, :datetime
      end

      s.table "users" do |t|
        t.column "id", :integer
        t.column "password_hash", :string
        t.column "first_name", :string
        t.column "last_name", :string
        t.column "email_address", :string
        t.column "group_id", :integer
        t.column "company_id", :integer
        t.column "active", :boolean
        t.column "created_at", :datetime
        t.column "updated_at", :datetime
        t.column "salt", :string
        t.column "remember_me_token", :string
        t.column "remember_me_token_expires_at", :datetime
      end
    end
  end

  class Status < ActiveRecord::Base ; end
  class Privilege < ActiveRecord::Base ; end
  class Group < ActiveRecord::Base ; end
  class User < ActiveRecord::Base ; end
  class Priority < ActiveRecord::Base ; end
  class Project < ActiveRecord::Base ; end

  # Make sure data you expect your migrations to load are in there:
  def see_default_data
    assert Status.find_by_name("defined")
    assert Status.find_by_name("in progress")
    assert Status.find_by_name("complete")
    assert Status.find_by_name("rejected")
    assert Status.find_by_name("blocked")
    
    assert Privilege.find_by_name("crud_companies")
    assert Privilege.find_by_name("crud_projects")       
    assert Privilege.find_by_name("crud_users")           
    assert Privilege.find_by_name("crud_companies_users") 
    assert Privilege.find_by_name("user")  
    
    assert Group.find_by_name("Developer")
    assert Group.find_by_name("Customer")
    assert Group.find_by_name("Customer Admin")
    assert Group.find_by_name("Admin")
    
    assert User.find_by_email_address("admin@example.com")

    priority_high = Priority.find_by_name("High")
    assert_equal "red", priority_high.color
    assert_nil priority_high.position
    
    priority_medium = Priority.find_by_name("Medium")
    assert_equal "yellow", priority_medium.color
    assert_nil priority_medium.position

    priority_low = Priority.find_by_name("Low")
    assert_equal "green", priority_low.color
    assert_nil priority_low.position
    
    assert_equal 1, Project.count(:conditions=>"name='Example Project'")
  end

  #
  # TESTS
  #

  def test_full_migration
    drop_all_tables
    
    see_empty_schema

    migrate

    see_full_schema

    see_default_data
  end

end
