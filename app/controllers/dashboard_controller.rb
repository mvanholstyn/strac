class DashboardController < ApplicationController
  
  def index
    @activities_date = Date.today - 1
    @projects = ProjectPermission.find_all_projects_for_user( current_user )
    render :template => "dashboard/index"
  end

end
