class LeadsController < ApplicationController
  def index
    @leads = leads
  end

  private

  def leads
    organization.leads
  end
end
