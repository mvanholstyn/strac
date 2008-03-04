class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'a38aedd25d926734dde3ef15f505a98d'
  
  include ExceptionLoggable
  
  helper :all
  
  restrict_to :user, :except => { :users => [ :login, :logout, :reminder, :reminder_login, :signup ] }
  
  on_permission_denied do
    flash[:error] = "You do not have the proper privileges to access this page."
    redirect_to dashboard_path
  end
  
  rescue_from AccessDenied, ResourceNotFoundError do |exception|
    redirect_to "/access_denied.html"
  end

private

  def render_error(msg)
    render :update do |page|
      page[:error].replace_html msg
      page[:notice].hide
      page[:error].show
      page.visual_effect :appear, :error
      page.delay(5) { page.visual_effect :fade, :notice }
      yield page if block_given?
    end
  end

  def render_notice(msg)
    render :update do |page|
      page[:notice].replace_html msg
      page[:error].hide
      page[:notice].show
      page.visual_effect :appear, :notice
      page.delay(5) { page.visual_effect :fade, :notice }
      yield page if block_given?
    end
  end
end
