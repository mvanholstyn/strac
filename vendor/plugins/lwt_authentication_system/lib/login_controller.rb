module LWT
  module AuthenticationSystem
    module LoginController

      def self.included base #:nodoc:
        base.extend ClassMethods
      end

      # These methods are added to ActionController::Base      
      module ClassMethods
        # Sets up this controller as a login controller. The following thigs are done:
        # * Adds methods from LWT::AuthenticationSystem::LoginController::InstanceMethods
        # * Adds methods from LWT::AuthenticationSystem::LoginController::SingletonMethods        
        #
        # Valid options:
        # - :login_flash - This is the message stored in flash[:notice] when
        #   prompting the user to login. Default: "Please login"
        # - :invalid_login_flash - This is the message stored in flash[:error]
        #   when a user attempts to login with invalid login credentials.
        #   Default: "Invalid login credentials"
        # - :track_pre_login_url - If true and the user attempts to go to a specific
        #   page before logging in, after logging in they will be redirected to
        #   the page they initially requested rather then the page defined by the
        #   after_login_redirect. Defatut: true
        def acts_as_login_controller( options = {} )
          include LWT::AuthenticationSystem::LoginController::InstanceMethods
          extend LWT::AuthenticationSystem::LoginController::SingletonMethods

          self.lwt_authentication_system_options = {
            :login_flash => "Please login",
            :invalid_login_flash => "Invalid login credentials",
            :inactive_login_flash => "Your account has not been activated",
            :signup_flash => "Please signup",
            :successful_signup_flash => "You have successfully signed up",
            :allow_signup => false,
            :reminder_flash => "Please enter the email address of the account whose information you would like to retrieve",
            :reminder_error_flash => "The email address you entered was not found",
            :reminder_success_flash => "Please check your email to retrieve your account information",
            :email_from => "Support",
            :reminder_login_duration => 2.hours,
            :reminder_email_subject => "Support Reminder",
            :signup_email_subject => "Welcome",
            :track_pre_login_url => true
          }.merge( options )
          
          if lwt_authentication_system_options[:allow_signup]
            include LWT::AuthenticationSystem::LoginController::SignupInstanceMethods
          end
          
          after_successful_signup do ; end
          after_failed_signup do ; end

          redirect_after_logout do
            { :action => 'login' }
          end

          redirect_after_signup do
            { :action => 'login' }
          end
        end
      end

      module SingletonMethods
        attr_accessor :lwt_authentication_system_options
        
        # Update restrict_to to automatically ignore the login, logout, reminder, profile, and signup actions
        def restrict_to *privileges, &blk
          options = privileges.last.is_a?( Hash ) ? privileges.pop : {}

          if not options[:only]
            options[:except] = Array(options[:except]) + [:login, :logout, :reminder, :profile, :signup]
          end
          
          privileges << options
          
          super( *privileges, &blk )
        end
        
        # Sets the arguments to be passed to redirect_to after a user
        # successfully logs in. The block will be evaluated in the scope
        # of the controller.
        def redirect_after_login &blk
          self.lwt_authentication_system_options[:redirect_after_login] = blk
        end

        # Sets the arguments to be passed to redirect_to after a user
        # successfully logs in. The block will be evaluated in the scope
        # of the controller.
        def redirect_after_reminder_login &blk
          self.lwt_authentication_system_options[:redirect_after_reminder_login] = blk
        end

        # Sets the arguments to be passed to redirect_to after a user
        # successfully logs out. The block will be evaluated in the scope
        # of the controller.
        def redirect_after_logout &blk
          self.lwt_authentication_system_options[:redirect_after_logout] = blk
        end

        def after_successful_signup &blk
          self.lwt_authentication_system_options[:after_successful_signup] = blk
        end
        
        def after_failed_signup &blk
          self.lwt_authentication_system_options[:after_failed_signup] = blk
        end

        # Sets the arguments to be passed to redirect_to after a user
        # successfully signs up. The block will be evaluated in the scope
        # of the controller.
        def redirect_after_signup &blk
          self.lwt_authentication_system_options[:redirect_after_signup] = blk
        end
      end

      module InstanceMethods
        # The login action performs three different tasks, depending on
        # the context.
        #
        # - If resuest.post? the parameters in params[:user] will be used to
        #   try to login the user.
        # - If a user is already logged in, they will be redirected to the
        #   page defined in redirect_after_login
        # - Else, the login template will be rendered.
        def login
          if request.post?
            instance_variable_set( "@#{self.class.login_model_name}", model = self.class.login_model.login( params[self.class.login_model_name.to_sym] ) )
            if model
              if model.active?
                if not params[:remember_me].blank?
                  model.remember_me! 
                  cookies[:remember_me_token] = { :value => model.remember_me_token , :expires => model.remember_me_token_expires_at }
                end
                set_current_user model
                do_redirect_after_login
                return
              else
                flash.now[:error] = self.class.lwt_authentication_system_options[:inactive_login_flash]
              end
            else
              flash.now[:error] = self.class.lwt_authentication_system_options[:invalid_login_flash]
            end
          elsif params[:id] and params[:token] and reminder = UserReminder.find(:first, :conditions => [ "user_id = ? AND token = ? AND expires_at >= ? ", params[:id], params[:token], Time.now ])
            model = self.class.login_model.find( reminder.user_id )
            model.update_attribute :active, true
            self.set_current_user model
            reminder.destroy
            do_redirect_after_reminder_login
          elsif self.current_user
            do_redirect_after_login
            return
          else
            instance_variable_set( "@#{self.class.login_model_name}", self.class.login_model.new )
            flash.now[:notice] ||= self.class.lwt_authentication_system_options[:login_flash]
          end
        end

        # The logout action resets the session and rediects the user to
        # the page defined in redirect_after_logout.
        def logout
          current_user.forget_me!
          cookies.delete(:remember_me_token)
          set_current_user nil
          redirect_to self.instance_eval( &self.class.lwt_authentication_system_options[:redirect_after_logout] )
        end

        def reminder
          if request.post?
            email_address = params[self.class.login_model_name.to_sym][:email_address]
            if email_address.blank? || ( model = self.class.login_model.find_by_email_address( email_address ) ).nil?
              flash.now[:error] = self.class.lwt_authentication_system_options[:reminder_error_flash]
            else
              reminder = UserReminder.create_for_user( model, Time.now + self.class.lwt_authentication_system_options[:reminder_login_duration] )
              url = url_for(:action => 'login', :id => model, :token => reminder.token)
              UserReminderMailer.deliver_reminder(model, reminder, url, 
                :from => self.class.lwt_authentication_system_options[:email_from], 
                :subject => self.class.lwt_authentication_system_options[:reminder_email_subject] )
              flash[:notice] = self.class.lwt_authentication_system_options[:reminder_success_flash]
              redirect_to :action => "login"
            end
          else
            instance_variable_set( "@#{self.class.login_model_name}", self.class.login_model.new )
            flash.now[:notice] = self.class.lwt_authentication_system_options[:reminder_flash]
          end
        end
        
        def profile
          if current_user
            instance_variable_set( "@#{self.class.login_model_name}", current_user )
    
            if request.put?
              respond_to do |format|
                if current_user.update_attributes(params[self.class.login_model_name.to_sym])
                  flash[:notice] = 'Your profile was successfully updated.'
                  format.html { do_redirect_after_login }
                  format.xml  { head :ok }
                else
                  format.html
                  format.xml  { render :xml => current_user.errors }
                end
              end
            end
          else
            redirect_to :action => "login"
          end
        end

      private
        def do_redirect_after_reminder_login
          if blk = self.class.lwt_authentication_system_options[:redirect_after_reminder_login]
            redirect_to self.instance_eval( &blk )
          else
            do_redirect_after_login
          end
        end
      
        def do_redirect_after_login
          if self.class.lwt_authentication_system_options[:track_pre_login_url] and session[:pre_login_url]
            redirect_to session[:pre_login_url]
            session[:pre_login_url] = nil
          else
            redirect_to self.instance_eval( &self.class.lwt_authentication_system_options[:redirect_after_login] )
          end
        end
      end

      module SignupInstanceMethods
        def signup
          instance_variable_set( "@#{self.class.login_model_name}", model = self.class.login_model.new( params[self.class.login_model_name.to_sym] ) )
          if request.post?
            model.active = false
            if model.save
              reminder = UserReminder.create_for_user( model, Time.now + self.class.lwt_authentication_system_options[:reminder_login_duration] )
              url = url_for(:action => 'login', :id => model, :token => reminder.token)
              UserReminderMailer.deliver_signup(model, reminder, url, 
                :from => self.class.lwt_authentication_system_options[:email_from], 
                :subject => self.class.lwt_authentication_system_options[:signup_email_subject] )
              flash[:notice] = self.class.lwt_authentication_system_options[:successful_signup_flash]
              instance_eval &self.class.lwt_authentication_system_options[:after_successful_signup]
              redirect_to self.instance_eval( &self.class.lwt_authentication_system_options[:redirect_after_signup] )
            else
              instance_eval &self.class.lwt_authentication_system_options[:after_failed_signup]              
            end
          else
            flash[:notice] = self.class.lwt_authentication_system_options[:signup_flash]
          end
        end
      end
    end
  end
end
