module LWT
  module AuthenticationSystem
    module Model

      def self.included base #:nodoc:
        base.extend ClassMethods
      end

      # These methods are added to ActiveRecord::Base
      module ClassMethods
        # Sets up this model as a login model. The following thigs are done:
        # * belongs_to :group
        # * validates_presence_of :email_address
        # * validates_uniqueness_of :email_address
        # * sets up validation to check that password and password_confirmation
        #   match if either are set (to something that is not blank)
        # * sets up after_validation callbacks to clear password and password_confirmation.
        #   If there were no errors on password, they password_hash will be set to the hash
        #   value of password
        # * Adds methods from LWT::AuthenticationSystem::Model::InstanceMethods
        # * Adds methods from LWT::AuthenticationSystem::Model::SingletonMethods
        #
        # Valid options:
        # - :password_validation - Error message used when the passwords do not match.
        #   If this check is not desired, set this to false or nil.
        #   Default: "must match"
        # - :email_address_validation - Error message used when the email_address is blank.
        #   If this check is not desired, set this to false or nil.
        #   Default: "can't be blank"
        # - :email_address_unique_validation - Error message used when the email_address is
        #   already in use. If this check is not desired, set to false or nil.
        #   Default: "has already been taken"
        def acts_as_login_model options = {}
          extend LWT::AuthenticationSystem::Model::SingletonMethods
          include LWT::AuthenticationSystem::Model::InstanceMethods

          self.lwt_authentication_system_options = {
            :group_validation => "can't be blank",
            :password_validation => "must match",
            :email_address_validation => "can't be blank",
            :email_address_unique_validation => "has already been taken"
          }.merge( options )

          hash_password do |password, salt|
            require 'digest/sha1'
            Digest::SHA1.hexdigest("--#{salt}--#{password}--")
          end

          belongs_to :group

          if msg = lwt_authentication_system_options[:group_validation]
            validates_presence_of :group_id, :message => msg
          end

          if msg = lwt_authentication_system_options[:email_address_validation]
            validates_presence_of :email_address, :message => msg
          end

          if msg = lwt_authentication_system_options[:email_address_unique_validation]
            validates_uniqueness_of :email_address, :message => msg
          end

          if msg = self.lwt_authentication_system_options[:password_validation]
            validate do |user|
              if ( user.instance_variable_get( "@password" ) or user.instance_variable_get( "@password_confirmation" ) ) && 
                 user.instance_variable_get( "@password" ) != user.instance_variable_get( "@password_confirmation" )
                user.errors.add( :password, msg )
                false
              else
                true
              end
            end
          end
          
          before_save do |user|
            if user.instance_variable_get( "@password" )
              require 'digest/sha1'
              user.salt ||= Digest::SHA1.hexdigest("--#{Time.now}--#{user.email_address}--")
              user.password_hash = self.hash_password( user.instance_variable_get( "@password" ), user.salt )
            end
          end
        end
      end

      module SingletonMethods
        attr_accessor :current_user, :lwt_authentication_system_options

        # Attempts to find a user by the passed in attributes. The param :password will
        # be removed and will be checked against the password of the user found (if any).
        def login params
          if not params.blank? and user = self.find_by_email_address(params[:email_address], :include => {:group => :privileges})
            self.hash_password(params[:password], user.salt) == user.password_hash ? user : nil
          end
        end

        # This method does two things:
        # - If given a block, that blocked is stored and used when hashing the users password.
        #   When the block is called, it will be given the password and the salt, if enabled.
        # - Else, the stored block is called, giving passing it all arguments
        def hash_password( *args, &blk )
          if blk
            self.lwt_authentication_system_options[:hash_password] = blk
          else
            self.lwt_authentication_system_options[:hash_password].call *args
          end
        end
      end

      module InstanceMethods
        
        def forget_me!
          self.remember_me_token_expires_at = nil
          self.remember_me_token = nil
          save_without_validation
        end
        
        def remember_me!
          require 'digest/sha1'
          self.remember_me_token_expires_at = 2.weeks.from_now
          self.remember_me_token = Digest::SHA1.hexdigest("--#{email_address}--#{remember_me_token_expires_at}--")
          save_without_validation
        end
        
        def password; end
        def password_confirmation; end
        
        # Sets the users password. This will be ignored if the value is blank.
        # This value is cleared out in an after_validate callback. If there
        # were not errors on the password attribute, then password_hash will be
        # set to the hash of this password.
        def password=( password )
          @password = password.blank? ? nil : password
        end

        # Sets the users password_confirmation. This will be itnored if the value is blank
        # This value is cleared out in an after_validate callback.
        def password_confirmation=( password )
          @password_confirmation = password.blank? ? nil : password
        end

        # This method returns true if this user has ANY of the passed in privileges.
        #
        # Valid options:
        # - :match_all - If set to true, returns true if this user has ALL of the 
        #   passed in privileges. Default: false
        def has_privilege? *requested_privileges
          options = requested_privileges.last.is_a?(Hash) ? requested_privileges.pop : {}
          matched_privileges = requested_privileges.map(&:to_s) & group.privileges.map(&:name)
          options[:match_all] ? matched_privileges.size == requested_privileges.size : !matched_privileges.empty?
        end
      end
    end
  end
end
