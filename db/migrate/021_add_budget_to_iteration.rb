class AddBudgetToIteration < ActiveRecord::Migration
  def self.up
    add_column :iterations, :budget, :integer, :default=>0
  end

  def self.down
    remove_column :iterations, :budget
  end
end
