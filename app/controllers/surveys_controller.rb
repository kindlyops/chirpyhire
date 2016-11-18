class SurveysController < ApplicationController
  decorates_assigned :survey

  def reorder
    @survey = authorize(current_organization.survey)
    QuestionOrderer.new(@survey)
                   .reorder(params[:questions])
    redirect_to survey_url, notice: 'Nice! Order saved.'
  end

  def edit
    @survey = authorize(current_organization.survey)
  end

  def show
    @survey = authorize(current_organization.survey)
  end
end
