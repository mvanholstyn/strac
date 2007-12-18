# == acts_as_comparable
# acts_as_comparable provides comparison to ActiveRecord models. 
# It allows you to capture what fields are different, as well as
# easy access to those diferrent values.
#
#  class MyModel < ActiveRecord::Base
#  acts_as_comparable
#  end
#
#
# == EXAMPLES
#
#  # default options which treats all fields as comparable
#  class Person < ActiveRecord::Base
#  acts_as_comparable
#  end
#
#  # specifying which fields that should act as comparable
#  class Person < ActiveRecord::Base
#    acts_as_comparable :only => [ :first_name, :last_name, :age ]
#  end
#
#
#  # specifying which fields shouldn't act as comparable
#  class Person < ActiveRecord::Base
#    acts_as_comparable :except => [ :eyecolor ]
#  end
#
#
#  # specifying fields which compare to another field on the same model
#  class Account < ActiveRecord::Base
#    acts_as_comparable :attrs_map => { :accountno => :parent_accountno }
#  end
#
# See unit tests for more usage examples.
#
# == AUTHORS
# * Mark Van Holstyn http://www.lotswholetime.com
# * Zach Dennis http://www.continuousthinking.com
#
module ActiveRecord::Acts ; end

module ActiveRecord::Acts::Comparable
  def self.included( base )
    base.extend ClassMethods
  end

  module ClassMethods
    
    # Sets up the current model to be comparable against other models or instances.
    #
    # == Options
    # * :only - an array of fields as symbols which should be held onto for comparison
    # * :except - an array of fields as symbols which should not be held onto for comparison
    # * :attrs_map - a hash of field to field mappings as symbols which define how fields should be compared  
    def acts_as_comparable( options = {} )
      #pullin in necessary methods
      cattr_accessor :comparable_options
      include ActiveRecord::Acts::Comparable::InstanceMethods
      
      #setup options
      self.comparable_options = options
    end
  
    private
    
    def comparable_options_to_attributes_hash( options )      
      options ||= {}
      
      #setup attributes
      attrs = {}
      
      if options[:only]
        options[:only].to_a.each { |attr| attrs[attr.to_sym] = attr.to_sym } 
      else
        self.column_names.each { |attr| attrs[attr.to_sym] = attr.to_sym } 
      end

      if options[:attrs_map]
        options[:attrs_map].each_pair do |attr,action| 
          attrs[attr.to_sym] = action
        end
      end
            
      if options[:except]
        options[:except].to_a.each { |attr| attrs.delete attr.to_sym } 
      end
      
      attrs
    end
  end

  module InstanceMethods
    
    # Returns true if the passed in +other+ model is different then this
    # model given the fields that are marked as comparable. Otherwise
    # returns false.
    #
    # == Arguments
    # * other - another ActiveRecord model to compare this model against
    # * options - a hash of options. All options for ActiveRecord::Acts::Comparable::ClassMethods.acts_as_comparable apply.
    #
    def different?( other = nil, options = nil )
      other ||= self.new_record? ? self.class.new : self.class.find( self.id )
      comparable_attributes_for( options ).each_pair do |attr, action|
        if action.is_a? Proc
          return true unless action.call( self ) == action.call( other )
        else
          return true unless self.send( attr ) == other.send( attr )
        end
      end
      false
    end
    
    # Returns true if the passed in +other+ model is comparable to this
    # model given the fields that are marked as comparable. Otherwise
    # returns false.
    #
    # == Arguments
    # * other - another ActiveRecord model to compare this model against
    # * options - a hash of options. All options for ActiveRecord::Acts::Comparable::ClassMethods.acts_as_comparable apply.
    #
    def same?( other = nil, options = nil )
      not different?( other, options )
    end
    
    # Returns a hash of field to value mappings which signify the differences between
    # this model object and the passed in +other+ model object given an optional
    # set of options. Returns an empty hash if there are no comparable differences.
    #
    # The value of the field to value mappings is an array of the values that differ.
    #
    # == Arguments
    # * other - another ActiveRecord model to compare this model against
    # * options - a hash of options. All options for ActiveRecord::Acts::Comparable::ClassMethods.acts_as_comparable apply.
    #
    # == Example
    #
    #  class Pet < ActiveRecord::Base ; end
    # 
    #  pet1 = Pet.new :id=>1, :name=>"dog", :value=>"Tiny"
    #  pet2 = Pet.new :id=>5, :name=>"cat", :value=>"Norm"
    #
    #  differences = pet1.differences(pet2)
    #  #  => {:value=>["Tiny", "Norm"], :name=>["dog", "cat"], :id=>[1, 5]}
    #
    def differences( other = nil, options = nil )
      other ||= self.new_record? ? self.class.new : self.class.find( self.id )
      diffs = {}
      comparable_attributes_for( options ).each_pair do |attr, action|
        unless self.send( attr ) == other.send( attr )
          if action.is_a? Proc
            diffs[attr] = [ action.call( self ), action.call( other ) ]
          else
            diffs[attr] = [ self.send( attr ), other.send( attr ) ]
          end
        end
      end
      diffs.symbolize_keys
    end
    
  private
    
    # Returns an hash of comparable attribute mappings given the passed in options.
    #
    # == Arguments
    # * options - a hash of options. All options for ActiveRecord::Acts::Comparable::ClassMethods.acts_as_comparable apply.
    def comparable_attributes_for( options )
      self.class.send( :comparable_options_to_attributes_hash, options || self.comparable_options )
    end
  end
  
end

ActiveRecord::Base.send( :include, ActiveRecord::Acts::Comparable )
