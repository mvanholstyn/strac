# == Schema Information
# Schema version: 32
#
# Table name: invitations
#
#  id         :integer(11)   not null, primary key
#  inviter_id :integer(11)   
#  recipient  :string(255)   
#  project_id :integer(11)   
#  kind       :string(255)   
#

class Invitation < ActiveRecord::Base
  belongs_to :inviter, :class_name => "User", :foreign_key => "inviter_id"
  belongs_to :project
  
  validates_presence_of :inviter_id, :project_id, :kind
    
  def self.build_from_string( str, attributes )
    str.to_s.split(/\n/).map do |email_address|
      Invitation.new attributes.merge( :recipient=>email_address )
    end
  end
  
end
