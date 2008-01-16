class UpdateIterationsToSti < ActiveRecord::Migration
  class Bucket < ActiveRecord::Base ; end
  
  def self.up
    drop_table :phases

    rename_table :iterations, :buckets
    add_column :buckets, :type, :string
    add_column :buckets, :description, :text
    Bucket.update_all "type = 'Iteration'"
    rename_column :stories, :iteration_id, :bucket_id
  end
  
  def self.down
    remove_column :buckets, :type
    remove_column :buckets, :description
    rename_table :buckets, :iterations
    rename_column :stories, :bucket_id, :iteration_id

    create_table :phases do |t|
      t.string :name
      t.integer :project_id
      t.timestamps
    end    
  end
end
