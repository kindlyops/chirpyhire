class Billing::CompaniesController < ApplicationController
  def show
    @organization = authorize(current_organization)
  end
end
