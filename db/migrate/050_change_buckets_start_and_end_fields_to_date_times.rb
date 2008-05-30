class ChangeBucketsStartAndEndFieldsToDateTimes < ActiveRecord::Migration
  def self.up
    change_column :buckets, :start_date, :datetime
    change_column :buckets, :end_date, :datetime
    rename_column :buckets, :start_date, :started_at
    rename_column :buckets, :end_date, :ended_at
  end

  def self.down
    rename_column :buckets, :started_at, :start_date
    rename_column :buckets, :ended_at, :end_date
    change_column :buckets, :start_date, :date
    change_column :buckets, :end_date, :date
  end
end
