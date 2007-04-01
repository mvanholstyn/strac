class Story < ActiveRecord::Base
  belongs_to :iteration
  belongs_to :project
  belongs_to :status
  belongs_to :priority
  belongs_to :responsible_party, :polymorphic => true
  has_many :time_entries, :as => :timeable
  has_many :activities, :as => :affected

  acts_as_list :scope => :iteration_id
  acts_as_taggable
  acts_as_textiled :description

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
  def self.reorder ids, attributes = {}
    attribute_names = attributes.merge( :id => nil, :position => nil ).keys
    sql = "INSERT INTO #{self.table_name}(#{attribute_names.join( ",")}) VALUES"
    sql_values, values = [], []
    ids.each_with_index do |story_id, index|
      attributes = attributes.merge( :id => story_id, :position => index )
      sql_values << "(#{attribute_names.map { "?" }.join( "," )})"
      values.push( *attribute_names.map { |a| attributes[a] } )
    end
    sql << sql_values.join( "," ) << " ON DUPLICATE KEY UPDATE " <<
      "#{attribute_names.map { |a| "#{a}=VALUES(#{a})" }.join( "," )}"
    connection.insert( sanitize_sql( [ sql ] + values ) )
    true
  rescue Exception => e
    logger.error "Rescued Exception in Story.reorder: #{e.to_s}\n\t#{e.backtrace.join("\n\t")}"
    false
  end
  
  def self.find_backlog options = {}
    with_scope :find => options do
      find :all, :conditions => { :iteration_id => nil }
    end
  end
end
