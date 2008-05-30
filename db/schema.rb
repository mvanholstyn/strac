# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 50) do

  create_table "activities", :force => true do |t|
    t.integer  "actor_id"
    t.string   "action"
    t.datetime "created_at"
    t.integer  "project_id"
    t.integer  "affected_id"
    t.string   "affected_type"
    t.datetime "updated_at"
  end

  create_table "buckets", :force => true do |t|
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "project_id"
    t.string   "name"
    t.integer  "budget",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.text     "description"
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.integer  "commenter_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_privileges", :force => true do |t|
    t.integer  "group_id"
    t.integer  "privilege_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "inviter_id"
    t.string   "recipient"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.string   "message"
  end

  create_table "logged_exceptions", :force => true do |t|
    t.string   "exception_class"
    t.string   "controller_name"
    t.string   "action_name"
    t.text     "message"
    t.text     "backtrace"
    t.text     "environment"
    t.text     "request"
    t.datetime "created_at"
  end

  create_table "priorities", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "privileges", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_permissions", :force => true do |t|
    t.integer  "project_id"
    t.integer  "accessor_id"
    t.string   "accessor_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "iteration_length"
  end

  create_table "snapshots", :force => true do |t|
    t.integer  "total_points"
    t.integer  "completed_points"
    t.integer  "remaining_points"
    t.float    "average_velocity"
    t.float    "estimated_remaining_iterations"
    t.date     "estimated_completion_date"
    t.integer  "bucket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stories", :force => true do |t|
    t.string   "summary"
    t.text     "description"
    t.integer  "points"
    t.integer  "position"
    t.integer  "bucket_id"
    t.integer  "project_id"
    t.integer  "responsible_party_id"
    t.string   "responsible_party_type"
    t.integer  "status_id"
    t.integer  "priority_id"
    t.datetime "created_at"
    t.datetime "completed_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string  "taggable_type"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "time_entries", :force => true do |t|
    t.decimal  "hours",         :precision => 10, :scale => 2
    t.string   "comment"
    t.date     "date"
    t.integer  "project_id"
    t.integer  "timeable_id"
    t.string   "timeable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_reminders", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "expires_at"
  end

  create_table "users", :force => true do |t|
    t.string   "password_hash"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
    t.string   "salt"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
  end

end
