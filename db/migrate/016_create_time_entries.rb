class CreateTimeEntries < ActiveRecord::Migration
  def self.up
    create_table :time_entries do |t|
      t.column :hours, :decimal, :precision => 10, :scale => 2
      t.column :comment, :string
      t.column :date, :date
      t.column :project_id, :integer
      t.column :timeable_id, :integer
      t.column :timeable_type, :string
    end
  end

  def self.down
    drop_table :time_entries
  end
end
