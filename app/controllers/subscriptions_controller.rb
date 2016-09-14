class SubscriptionsController < ApplicationController
  skip_before_action :block_invalid_subscriptions
  before_action :ensure_new_subscription, only: [:new, :create]

  def new
    @subscription = authorized_subscription
  end

  def edit
    @subscription = authorized_subscription
  end

  def show
    @subscription = authorized_subscription
  end

  def update
    @subscription = authorized_subscription

    if @subscription.update(permitted_attributes(Subscription))
      Payment::Subscriptions::Update.call(@subscription)
      SurveyAdvancer.call(current_organization)

      redirect_to subscription_path(@subscription), notice: "Nice! Subscription changed."
    else
      render :edit
    end
  rescue Stripe::CardError => e
    flash[:alert] = stripe_error_message(e)
    render :edit
  end

  def create
    @subscription = authorized_subscription

    if params[:stripe_token].present? && @subscription.update(permitted_attributes(Subscription))
      current_organization.update(stripe_token: params[:stripe_token])
      Payment::Subscriptions::Process.call(@subscription, current_account.email)
      @subscription.activate!
      SurveyAdvancer.call(current_organization)

      redirect_to subscription_path(@subscription), notice: "Nice! Subscription created."
    else
      render :new
    end
  rescue Stripe::CardError => e
    flash[:alert] = stripe_error_message(e)
    render :new
  end

  def destroy
    @subscription = authorized_subscription
    Payment::Subscriptions::Cancel.call(@subscription)
    @subscription.cancel!
    redirect_to subscription_path(@subscription), notice: "Sorry to see you go. Your account is canceled."
  rescue Stripe::CardError => e
    flash[:alert] = stripe_error_message(e)
    render :edit
  end

  private

  def stripe_error_message(error)
    <<-ERROR
#{error.message} Need Help? <a href='javascript:void(0)' onclick="Intercom('showNewMessage')">Message Us</a>
    ERROR
  end

  def authorized_subscription
    @authorized_subscription ||= authorize current_organization.subscription
  end

  def ensure_new_subscription
    unless authorized_subscription.trialing? && authorized_subscription.stripe_id.blank?
      redirect_to edit_subscription_path(authorized_subscription)
    end
  end
end
