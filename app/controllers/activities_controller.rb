class ActivitiesController < ApplicationController
  decorates_assigned :activity, :activities

  def show
    @activity = authorized_activity

    respond_to do |format|
      format.js {
        render layout: false
      }
    end
  end

  def index
    @activities = scoped_activities

    respond_to do |format|
      format.js {
        render partial: "activities/activities"
      }
    end
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
