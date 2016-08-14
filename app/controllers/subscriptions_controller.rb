class SubscriptionsController < ApplicationController
  include Payola::StatusBehavior
  layout "application"

  def new
    @subscription = authorize current_organization.build_subscription
  end

  def edit
  end

  def create
    authorize current_organization.build_subscription
    owner = current_organization
    params[:plan] = SubscriptionPlan.find_by(id: params[:plan_id])
    subscription = Payola::CreateSubscription.call(params, owner)
    render_payola_status(subscription)
  end
end
