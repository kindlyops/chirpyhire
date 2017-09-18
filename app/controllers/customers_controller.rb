class CustomersController < ApplicationController
  def create
    create_customer
  rescue Stripe::CardError => e
    flash[:error] = e.message
  ensure
    redirect_to organization_billing_company_path(organization)
  end

  def update
    update_customer
  rescue Stripe::CardError => e
    flash[:error] = e.message
  ensure
    redirect_to organization_billing_company_path(organization)
  end

  private

  def create_customer
    organization.update(stripe_customer_id: customer.id)
    create_payment_card
    Internal::Notification::Customer.call(organization)
    organization.subscription.activate
  end

  def update_customer
    add_payment_card
    Internal::Notification::Customer.call(organization)
  end

  def add_payment_card
    organization.payment_cards.create(
      stripe_id: new_payment_card.id,
      brand: new_payment_card.brand,
      exp_month: new_payment_card.exp_month,
      exp_year: new_payment_card.exp_year,
      last4: new_payment_card.last4
    )
  end

  def new_payment_card
    @new_payment_card ||= begin
      stripe_customer.sources.create(source: params[:stripeToken])
    end
  end

  def stripe_customer
    @stripe_customer ||= begin
      Stripe::Customer.retrieve(organization.stripe_customer_id)
    rescue Stripe::InvalidRequestError
      create_stripe_customer
    end
  end

  def create_stripe_customer
    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken],
      description: organization.name
    )
    organization.update(stripe_customer_id: customer.id)
    customer
  end

  def customer
    @customer ||= begin
      Stripe::Customer.create(
        email: params[:stripeEmail],
        source: params[:stripeToken],
        description: organization.name
      )
    end
  end

  def create_payment_card
    organization.payment_cards.create(
      stripe_id: card.id,
      brand: card.brand,
      exp_month: card.exp_month,
      exp_year: card.exp_year,
      last4: card.last4
    )
  end

  def card
    customer.sources.first
  end

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end
end
