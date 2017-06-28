class CustomersController < ApplicationController
  def create
    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken]
    )

    organization.update(stripe_customer_id: customer.id)
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to organization_billing_company_path(organization)
  end

  private

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end
end
