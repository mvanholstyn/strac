class TextileController < ApplicationController
  def preview
    render :text => RedCloth.new( params[:textile] ).to_html
  end
end
