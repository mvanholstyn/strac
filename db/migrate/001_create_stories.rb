class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.column :summary, :string
      t.column :description, :text
      t.column :points, :integer
      t.column :position, :integer
      t.column :complete, :boolean
    end
  end

  def self.down
    drop_table :stories
  end
end
