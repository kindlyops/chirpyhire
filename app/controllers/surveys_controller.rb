class SurveysController < ApplicationController
  skip_after_action :verify_authorized, only: :show
  decorates_assigned :survey

  def show
    @survey = current_organization.survey
  end
end
