class LinkStoriesToProjects < ActiveRecord::Migration
  def self.up
    add_column :stories, :project_id, :integer
  end

  def self.down
    remove_column :stories, :project_id
  end
end
