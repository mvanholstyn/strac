class Bucket < ActiveRecord::Base
  belongs_to :project
  has_one :snapshot, :dependent => :destroy  
  has_many :stories, :order => :position, :dependent => :nullify

  validates_presence_of :project_id, :name

  def completed_stories
    stories.find(:all, :conditions => ['status_id=?', Status.complete.id], :order => "position ASC")
  end

  def display_name
    name
  end
end