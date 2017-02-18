class DashboardsController < ApplicationController
  def show
    @dashboard = authorize Dashboard.new(current_organization)
  end
end
