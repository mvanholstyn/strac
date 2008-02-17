class DashboardController < ApplicationController
  def index
    @projects = ProjectPermission.find_all_projects_for_user(current_user)
  end
end
