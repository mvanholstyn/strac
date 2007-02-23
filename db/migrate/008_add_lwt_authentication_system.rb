class AddLwtAuthenticationSystem < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column :name, :string
    end

    create_table :privileges do |t|
      t.column :name, :string
    end

    create_table :groups_privileges do |t|
      t.column :group_id, :integer
      t.column :privilege_id, :integer
    end

    create_table :users do |t|
      t.column :username, :string
      t.column :password_hash, :string
      t.column :group_id, :integer
    end
  end

  def self.down
    drop_table :users
    drop_table :groups_privileges
    drop_table :privileges
    drop_table :groups
  end
end
