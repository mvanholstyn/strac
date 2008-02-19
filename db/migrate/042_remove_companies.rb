class RemoveCompanies < ActiveRecord::Migration
  class ProjectPermission < ActiveRecord::Base ; end
  
  def self.up
    remove_column :users, :company_id
    drop_table :companies
    ProjectPermission.delete_all "accessor_type = 'Company'"
  end

  def self.down
    create_table "companies", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_column :users, :company_id, :integer
  end
end
