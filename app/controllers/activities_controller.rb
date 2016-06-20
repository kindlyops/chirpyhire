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
    @activities = scoped_activities.order(created_at: :desc)

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
    policy_scope(Activity).where(owner: activity_user)
  end

  def authorized_activity
    authorize Activity.find(params[:id])
  end

  def activity_user
    @user ||= begin
      activity_user = User.find(params[:user_id])
      if UserPolicy.new(current_account, activity_user).show?
        activity_user
      else
        raise Pundit::NotAuthorizedError
      end
    end
  end
end
