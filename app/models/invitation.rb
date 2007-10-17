# == Schema Information
# Schema version: 41
#
# Table name: invitations
#
#  id         :integer(11)   not null, primary key
#  inviter_id :integer(11)   
#  recipient  :string(255)   
#  project_id :integer(11)   
#  created_at :datetime      
#  updated_at :datetime      
#  code       :string(255)   
#

class Invitation < ActiveRecord::Base
  belongs_to :inviter, :class_name => "User", :foreign_key => "inviter_id"
  belongs_to :project
  
  validates_presence_of :inviter_id, :project_id

  def self.create_for(project, inviter, recipients)
    recipients.split(/\s*,\s*/).map do |recipient|
      Invitation.create!(:project => project, :inviter => inviter, :recipient => recipient, 
                         :code => UniqueCodeGenerator.generate(recipient))
    end
  end

end
