class Billing::CompaniesController < ApplicationController
  def show
    organization
  end

  def update
    if organization.update(permitted_attributes(Organization))
      redirect_to company_show_page, notice: update_notice
    else
      render :show
    end
  end

  private

  def company_show_page
    organization_billing_company_path(organization)
  end

  def update_notice
    'Nice! Invoice preferences saved.'
  end

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end
end
