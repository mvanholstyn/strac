class ApplicationController < ActionController::Base
  restrict_to :user, :except => { :users => [ :login, :logout ] }

  private

  def render_error msg
    render :update do |page|
      page[:error].replace_html msg
      page[:notice].hide
      page[:error].show
      page.visual_effect :appear, :error
      page.delay( 10 ) {  page.visual_effect :fade, :notice }
      yield page if block_given?
    end
  end

  def render_notice msg
    render :update do |page|
      page[:notice].replace_html msg
      page[:error].hide
      page[:notice].show
      page.visual_effect :appear, :notice
      page.delay( 10 ) {  page.visual_effect :fade, :notice }
      yield page if block_given?
    end
  end
end
