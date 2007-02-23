class Story < ActiveRecord::Base
  belongs_to :iteration
  belongs_to :project

  acts_as_list :scope => :iteration_id
  acts_as_taggable
  acts_as_textiled :description

  validates_presence_of :summary, :project
  validates_numericality_of :points, :position, :allow_nil => true

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
end
