class SurveyorJob < ApplicationJob
  def perform(subscriber)
    Surveyor.new(subscriber).call
  end
end
