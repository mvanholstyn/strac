class AddIterationSnapshotFields < ActiveRecord::Migration
  def self.up
    create_table :snapshots do |t|
      t.integer :total_points
      t.integer :completed_points
      t.integer :remaining_points
      t.float   :average_velocity
      t.float   :estimated_remaining_iterations
      t.date    :estimated_completion_date
      t.integer :bucket_id
      t.timestamps
    end
  end

  def self.down
    drop_table :snapshots
  end
end
