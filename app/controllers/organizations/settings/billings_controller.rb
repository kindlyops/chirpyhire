class Organizations::Settings::BillingsController < ApplicationController
  def show
    @profile = authorize(current_organization)
  end
end
