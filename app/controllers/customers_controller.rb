class CustomersController < ApplicationController
  def create
    customer = create_customer
    create_payment_card(customer.sources.first)
    Internal::Notification::Customer.call(organization)
  rescue Stripe::CardError => e
    flash[:error] = e.message
  ensure
    redirect_to organization_billing_company_path(organization)
  end

  private

  def create_customer
    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken],
      description: organization.name
    )
    Rails.logger.debug("STRIPE_CUSTOMER: #{customer.to_hash}")

    organization.update(stripe_customer_id: customer.id)
    customer
  end

  def create_payment_card(card)
    organization.payment_cards.create(
      stripe_id: card.id,
      brand: card.brand,
      exp_month: card.exp_month,
      exp_year: card.exp_year,
      last4: card.last4
    )
  end

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end
end
