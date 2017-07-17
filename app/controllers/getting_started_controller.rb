class GettingStartedController < ApplicationController
  skip_after_action :verify_authorized

  def show
    redirect_to engage_bot_path(current_organization.recent_bot)
  end
end
