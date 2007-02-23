class ApplicationController < ActionController::Base
  session :session_key => '_strac_session_id', :secret => "_strac_session_secret"

  restrict_to :user, :except => { :users => [ :login, :logout ] }

  private

  def render_error msg
    render :update do |page|
      page[:error].replace_html msg
      page[:notice].hide
      page[:error].show
      page.visual_effect :highlight, :error
      yield page if block_given?
    end
  end

  def render_notice msg
    render :update do |page|
      page[:notice].replace_html msg
      page[:error].hide
      page[:notice].show
      page.visual_effect :highlight, :notice
      yield page if block_given?
    end
  end
end
