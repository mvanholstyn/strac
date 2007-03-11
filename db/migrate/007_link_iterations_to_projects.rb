class LinkIterationsToProjects < ActiveRecord::Migration
  def self.up
    add_column :iterations, :project_id, :integer
  end

  def self.down
    remove_column :iterations, :project_id
  end
end
