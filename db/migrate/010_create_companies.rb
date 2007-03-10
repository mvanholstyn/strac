class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :companies
  end
end
