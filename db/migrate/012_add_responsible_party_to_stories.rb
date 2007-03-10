class AddResponsiblePartyToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :responsible_party_id, :integer
    add_column :stories, :responsible_party_type, :string
  end

  def self.down
    remove_column :stories, :responsible_party_id
    remove_column :stories, :responsible_party_type
  end
end
