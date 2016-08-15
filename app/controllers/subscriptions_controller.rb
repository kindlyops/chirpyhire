class SubscriptionsController < ApplicationController

  def new
    @subscription = authorize current_organization.build_subscription(plan: Plan.first)
  end

  def edit
    @subscription = authorize Subscription.find(params[:id])
  end

  def update
    @subscription = authorize Subscription.find(params[:id])

    if @subscription.update(permitted_attributes(Subscription))
      Payment::UpdateSubscriptionJob.perform_later(@subscription)

      redirect_to edit_subscription_path(@subscription), notice: "Nice! Subscription changed."
    else
      render :edit
    end
  end

  def create
    @subscription = authorize(new_subscription)

    current_organization.update(stripe_token: params[:stripe_token])

    if @subscription.save
      Payment::ProcessSubscriptionJob.perform_later(@subscription)
      redirect_to edit_subscription_path(@subscription), notice: "Nice! Subscription created."
    else
      render :new
    end
  end

  private

  def new_subscription
    current_organization.build_subscription(permitted_attributes(Subscription))
  end
end
