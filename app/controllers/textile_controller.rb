class TextileController < ApplicationController
  restrict_to :user

  def preview
    @preview = RedCloth.new(params[:textile]).to_html
    render :layout => false
  end
end
