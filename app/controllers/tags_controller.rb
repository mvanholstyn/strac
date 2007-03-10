class TagsController < ApplicationController
  
  def auto_complete
    @tags = Tag.find :all, :conditions => "name LIKE '%#{params[:tag]}%'"
    render :layout => false
  end
end
