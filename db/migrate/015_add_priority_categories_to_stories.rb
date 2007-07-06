class AddPriorityCategoriesToStories < ActiveRecord::Migration
  class Priority < ActiveRecord::Base ; end
  
  def self.up
    add_column :stories, :priority_id, :integer
    create_table :priorities do |t|
      t.column :name, :string
    end

    Priority.create! :name=>'Low'
    Priority.create! :name=>'Medium'
    Priority.create! :name=>'High'
  end

  def self.down
    drop_table :priorities
    remove_column :stories, :priority_id
  end

end
