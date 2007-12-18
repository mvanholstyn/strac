module LWT
  module AuthenticationSystem
    module Controller

      def self.included base #:nodoc:
        base.extend ClassMethods
        base.send :include, InstanceMethods

        base.class_inheritable_accessor :permission_granted, :permission_denied, :not_logged_in, :login_model_name, :login_controller_name
        base.helper_method :current_user, :restrict_to

        base.before_filter :find_and_set_current_user

        base.set_login_model :user
        base.set_login_controller :users_controller

        base.on_not_logged_in do
          redirect_to :controller => self.class.login_controller_name.gsub( /_controller$/, '' ), :action => 'login'
        end

        base.on_permission_denied do
          respond_to do |wants|
            wants.html { render :text => "You do not have the proper privileges to access this page.", :status => :unauthorized }
            wants.any { head :unauthorized }
          end
        end
        
        base.on_permission_granted do
          true
        end
      end

      # These methods are added to ActionController::Base
      module ClassMethods
        # This is used to restrict access to action based on privileges of the current user.
        # This method takes a list of privileges which should be allowes, as well as the options
        # hash which will be passed to before_filter.
        def restrict_to *privileges, &blk          
          options = privileges.last.is_a?( Hash ) ? privileges.pop : {}

          before_filter( options ) do |c|
            if !c.current_user.is_a? self.login_model
              c.session[:pre_login_url] = c.url_for( c.params )
              c.instance_eval &c.class.not_logged_in
            elsif c.current_user.has_privilege?( *privileges ) or (blk and c.instance_eval &blk)
              c.instance_eval &c.class.permission_granted
            else
              c.instance_eval &c.class.permission_denied
            end
          end
        end

        # Callback used when no user is logged in. The return value will
        # be the return value for the before_filter. This defaults to redirecting
        # to the 'users/login' action. The block will be evaluated in the scope
        # of the controller.
        def on_not_logged_in &blk
          self.not_logged_in = blk
        end

        # Callback used when a user is denied access to a page. The return value will
        # be the return value for the before_filter. The block will be evaluated in the scope
        # of the controller.
        def on_permission_denied &blk
          self.permission_denied = blk
        end

        # Callback used when a user is granted access to a page. The return value will
        # be the return value for the before_filter. The block will be evaluated in the scope
        # of the controlle.
        def on_permission_granted &blk
          self.permission_granted = blk
        end

        def set_login_model model_name
          self.login_model_name = model_name.to_s
        end

        def set_login_controller controller_name
          self.login_controller_name = controller_name.to_s
        end

        def login_model
          self.login_model_name.classify.constantize
        end
      end
      
      # These methods are added to ActionController::Base
      module InstanceMethods
        def current_user
          self.class.login_model.current_user
        end

        def restrict_to *privileges, &blk
          if current_user.is_a?( self.class.login_model ) and current_user.has_privilege?( *privileges )
            blk.call
          end
        end

        def set_current_user user
          if user.is_a? self.class.login_model
            session[:current_user_id] = user.id
            self.class.login_model.current_user = user
          else
            session[:current_user_id] = nil
            self.class.login_model.current_user = nil
          end
        end
        
        def find_and_set_current_user
          if session[:current_user_id]
            set_current_user self.class.login_model.find(session[:current_user_id], :include => {:group => :privileges })
          elsif cookies[:remember_me_token]
            model = self.class.login_model.find(:first, :conditions => ["remember_me_token = ? AND remember_me_token_expires_at >= ?", cookies[:remember_me_token], Time.now], :include => {:group => :privileges })
            if model
              model.remember_me!
              cookies[:remember_me_token] = { :value => model.remember_me_token , :expires => model.remember_me_token_expires_at }
            end
            set_current_user model 
          elsif not ActionController::HttpAuthentication::Basic.authorization(request).blank?
            model = authenticate_with_http_basic do |email_address, password|
              self.class.login_model.login(:email_address => email_address, :password => password)
            end
            
            if model
              set_current_user model
            else
              set_current_user nil
              instance_eval &self.class.permission_denied
            end
          else
            set_current_user nil
          end
        end
      end
    end
  end
end
