class AddNameToIteration < ActiveRecord::Migration
  def self.up
    add_column :iterations, :name, :string
  end

  def self.down
    remove_column :iterations, :name
  end
end
