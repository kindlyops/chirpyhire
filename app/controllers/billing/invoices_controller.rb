class Billing::InvoicesController < ApplicationController
  def index
    organization
    @invoices = policy_scope(Invoice)
  end

  private

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end
end
