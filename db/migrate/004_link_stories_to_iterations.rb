class LinkStoriesToIterations < ActiveRecord::Migration
  def self.up
    add_column :stories, :iteration_id, :integer
  end

  def self.down
    remove_column :stories, :iteration_id
  end
end
