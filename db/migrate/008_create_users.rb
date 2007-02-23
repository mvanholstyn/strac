class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :username, :string
      t.column :password_hash, :string
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :email_address, :string
      t.column :group_id, :integer
    end
  end

  def self.down
    drop_table :users
  end
end
