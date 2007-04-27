# == Schema Information
# Schema version: 32
#
# Table name: priorities
#
#  id       :integer(11)   not null, primary key
#  name     :string(255)   
#  color    :string(255)   
#  position :integer(11)   
#

class Priority < ActiveRecord::Base
  has_many :stories
  
  acts_as_list
end
