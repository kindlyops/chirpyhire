class SurveysController < ApplicationController
  decorates_assigned :survey

  def update
    if authorize(current_organization.survey).update(permitted_attributes(Survey))
      redirect_to survey_url, notice: "Nice! Order saved."
    else
      render :edit
    end
  end

  def edit
    @survey = authorize(current_organization.survey)
  end

  def show
    @survey = authorize(current_organization.survey)
  end
end
