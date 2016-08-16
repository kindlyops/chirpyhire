class SubscriptionsController < ApplicationController
  skip_before_action :block_invalid_subscriptions, only: [:edit, :update, :show]

  def new
    @subscription = authorize current_organization.build_subscription(plan: Plan.first)
  end

  def edit
    @subscription = authorize Subscription.find(params[:id])
  end

  def show
    @subscription = authorize Subscription.find(params[:id])
  end

  def update
    @subscription = authorize Subscription.find(params[:id])

    if @subscription.update(permitted_attributes(Subscription))
      Payment::Job::UpdateSubscription.perform_later(@subscription)

      redirect_to subscription_path(@subscription), notice: "Nice! Subscription changed."
    else
      render :edit
    end
  end

  def create
    @subscription = authorize(new_subscription)

    current_organization.update(stripe_token: params[:stripe_token])

    if @subscription.save
      Payment::Job::ProcessSubscription.perform_later(@subscription, current_account.email)
      redirect_to subscription_path(@subscription), notice: "Nice! Subscription created."
    else
      render :new
    end
  end

  def destroy
    @subscription = authorize Subscription.find(params[:id])
    if @subscription.cancel!
      Payment::Job::CancelSubscription.perform_later(@subscription)
      redirect_to subscription_path(@subscription), notice: "Sorry to see you go. Your account is canceled."
    else
      render :edit
    end
  end

  private

  def new_subscription
    current_organization.build_subscription(permitted_attributes(Subscription))
  end
end
