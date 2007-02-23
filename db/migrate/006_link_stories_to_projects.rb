class LinkStoriesToProjects < ActiveRecord::Migration
  def self.up
    add_column :stories, :project_id, :integer
  end

  def self.down
    add_column :stories, :project_id
  end
end
