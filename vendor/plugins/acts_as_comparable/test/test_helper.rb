unless Object.const_defined?( :ActiveRecord )
  begin 
    require 'active_record'
  rescue LoadError => ex
    require 'rubygems'
    require 'active_record'
  end
end

require File.join( File.dirname( __FILE__ ), '..', 'init' )
require 'test/unit'
require 'mocha'

###### SETUP a partially mocked out Model for testing #######

class DummyModel < ActiveRecord::Base
  class << self 
    def column_names
      %w[ id name value ]
    end
  end  
  
  acts_as_comparable
  
  def initialize( attributes_hsh={} )
    @attributes = { :id=>nil, :name=>"", :value=>"" }.merge( attributes_hsh )
    @new_record = true
    
    @attributes.keys.each do |column_name|
      self.class.send( :define_method, column_name ) { @attributes[column_name] }
    end
  end
end
