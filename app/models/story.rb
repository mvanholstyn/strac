# == Schema Information
# Schema version: 32
#
# Table name: stories
#
#  id                     :integer(11)   not null, primary key
#  summary                :string(255)   
#  description            :text          
#  points                 :integer(11)   
#  position               :integer(11)   
#  iteration_id           :integer(11)   
#  project_id             :integer(11)   
#  responsible_party_id   :integer(11)   
#  responsible_party_type :string(255)   
#  status_id              :integer(11)   
#  priority_id            :integer(11)   
#

class Story < ActiveRecord::Base
  belongs_to :iteration
  belongs_to :project
  belongs_to :status
  belongs_to :priority
  belongs_to :responsible_party, :polymorphic => true
  has_many :time_entries, :as => :timeable
  has_many :comments, :as => :commentable
  has_many :activities, :as => :affected 

  acts_as_list :scope => :iteration_id
  acts_as_taggable
  acts_as_textiled :description
  acts_as_comparable

  validates_presence_of :summary, :project_id
  validates_numericality_of :points, :position, :allow_nil => true

  def name
    summary
  end

  def responsible_party_type_id
    responsible_party ? "#{responsible_party.class.name.downcase}_#{responsible_party.id}" : ""
  end

  def responsible_party_type_id=( type_id )
    type, id = type_id.scan( /^(\w+)_(\d+)$/ ).flatten
    self.responsible_party_id = id
    self.responsible_party_type = type ? type.camelize : nil
  end

  #TODO: Is there a better way to put this into a single SQL statement?
  def self.reorder ids, options={}
    options = options.symbolize_keys
    raise ArgumentError.new("iteration_id is required") unless options.has_key?(:iteration_id)
    
    iteration_id = options[:iteration_id]
    values = []
    ids.each_with_index do |id, index|
      values << [id, index+1, iteration_id]
    end
    
    columns2import = [:id, :position, :iteration_id]
    columns2update = [:position, :iteration_id]
    Story.import( columns2import, values, :on_duplicate_key_update=>columns2update, :validate=>false )
    true
  end
  
  def self.find_backlog options = {}
    with_scope :find => options do
      find :all, :conditions => { :iteration_id => nil }
    end
  end
  
  def complete?
    status && (status.name =~ /complete/ || status.name =~ /rejected/)
  end
  
  def incomplete?
    !complete?
  end
end
