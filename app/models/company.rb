# == Schema Information
# Schema version: 30
#
# Table name: companies
#
#  id   :integer(11)   not null, primary key
#  name :string(255)   
#

class Company < ActiveRecord::Base
  has_many :users
  has_many :stories, :as => :responsible_party
  has_many :projects, :through => :project_permissions
  has_many :project_permissions, :foreign_key => "accessor_id", :as => :accessor
end
