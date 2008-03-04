class AddTimeFrameFieldToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :iteration_length, :string
  end

  def self.down
    remove_column :projects, :iteration_length
  end
end
