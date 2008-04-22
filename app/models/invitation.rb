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
  attr_accessor :accept_invitation_url

  belongs_to :inviter, :class_name => "User", :foreign_key => "inviter_id"
  belongs_to :project
  
  validates_presence_of :inviter_id, :project_id
end
