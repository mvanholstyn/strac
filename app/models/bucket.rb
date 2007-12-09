class Bucket < ActiveRecord::Base
  belongs_to :project
  has_many :stories, :order => :position

  validates_presence_of :project_id, :name

  def display_name
    name
  end
end