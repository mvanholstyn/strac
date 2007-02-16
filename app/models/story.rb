class Story < ActiveRecord::Base
  belongs_to :iteration

  acts_as_list :scope => :iteration_id
  acts_as_taggable

  validates_presence_of :summary
  validates_numericality_of :points, :position, :allow_nil => true

  #TODO: Make this one SQL statement. Return true/false based on whether or not this was successful
  def self.reorder ids, attributes = {}
    ids.each_with_index do |story_id, index|
      Story.update story_id, attributes.merge( :position => index )
    end
    true
  rescue Exception => e
    logger.error "Rescued Exception in Story.reorder: #{e.to_s}\n\t#{e.backtrace.join("\n\t")}"
    false
  end
end
