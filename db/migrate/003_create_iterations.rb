class CreateIterations < ActiveRecord::Migration
  def self.up
    create_table :iterations do |t|
      t.column :start_date, :date
      t.column :end_date, :date
    end
  end

  def self.down
    drop_table :iterations
  end
end
