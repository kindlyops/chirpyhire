class AutomationsController < ApplicationController
  decorates_assigned :automation

  def show
    @automation = authorized_automation
  end

  private

  def authorized_automation
    authorize Automation.find(params[:id])
  end
end
