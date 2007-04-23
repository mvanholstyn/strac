# == Schema Information
# Schema version: 30
#
# Table name: comments
#
#  id               :integer(11)   not null, primary key
#  content          :text          
#  created_at       :datetime      
#  commenter_id     :integer(11)   
#  commentable_id   :integer(11)   
#  commentable_type :string(255)   
#

class Comment < ActiveRecord::Base
  belongs_to :commenter, :class_name => "User", :foreign_key => "commenter_id"
  belongs_to :commentable, :polymorphic => true
  
  validates_presence_of :commenter_id, :content, :commentable_id, :commentable_type
end
