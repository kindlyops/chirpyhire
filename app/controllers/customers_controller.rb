class CustomersController < ApplicationController
  def create
    create_customer
  rescue Stripe::CardError => e
    flash[:error] = e.message
  ensure
    redirect_to organization_billing_company_path(organization)
  end

  private

  def create_customer
    organization.update(stripe_id: customer.id)
    create_payment_card
    Internal::Notification::Customer.call(organization)
    organization.subscription.activate
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
