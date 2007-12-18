class AddLwtAuthenticationSystem < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
    end

    create_table :privileges do |t|
      t.string :name
    end

    create_table :groups_privileges do |t|
      t.integer :group_id
      t.integer :privilege_id
    end
    add_index :groups_privileges, :group_id
    add_index :groups_privileges, :privilege_id

    create_table :users do |t|
      t.string :password_hash
      t.string :salt
      t.string :email_address
      t.integer :group_id
      t.boolean :active
      t.string :remember_me_token
      t.datetime :remember_me_token_expires_at
    end
    add_index :users, :group_id
    
    create_table :user_reminders do |t|
      t.integer :user_id
      t.string :token
      t.datetime :expires_at
    end
    add_index :user_reminders, :user_id
  end

  def self.down
    drop_table :users
    drop_table :groups_privileges
    drop_table :privileges
    drop_table :groups
    drop_table :user_reminders
  end
end
