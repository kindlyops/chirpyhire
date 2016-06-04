class ActivitiesController < ApplicationController
  decorates_assigned :activity

  def show
    @activity = authorized_activity

    render layout: false
  end

  def index
    @activities = scoped_activities
  end

  def update
    authorized_activity.update(permitted_attributes(Activity))
    @activity = authorized_activity

    respond_to do |format|
      format.js {}
    end
  end

  private

  def scoped_activities
    policy_scope(Activity).outstanding
  end

  def authorized_activity
    authorize Activity.find(params[:id])
  end
end
