class SubscriptionsController < ApplicationController
  before_action :ensure_no_subscription, only: :new

  def new
    @subscription = authorize current_organization.build_subscription(plan: Plan.first)
  end

  def edit
    @subscription = authorize Subscription.find(params[:id])
  end

  def show
    @subscription = authorize Subscription.find(params[:id])

    render_payment_status(@subscription)
  end

  def create
    @subscription = authorize(new_subscription)

    Payment::Subscriptions::Create.call(@subscription, params[:stripe_token])

    render_payment_status(@subscription)
  end

  private

  def ensure_no_subscription
    if current_organization.subscription.persisted?
      redirect_to edit_subscription_path(current_organization.subscription)
    end
  end

  def new_subscription
    current_organization.build_subscription(permitted_attributes(Subscription))
  end

  def render_payment_status(subscription)
    head :not_found and return unless subscription

    errors = subscription.errors.full_messages.to_sentence

    render json: {
      id:   subscription.id,
      state: subscription.state,
      error:  errors.presence
    }, status: errors.blank? ? 200 : 400
  end
end
