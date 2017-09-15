class Billing::InvoicesController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index

  def index
    @organization = organization
  end

  private

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end
end
