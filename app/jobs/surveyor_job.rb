class SurveyorJob < ApplicationJob
  def perform(subscriber)
    Surveyor.new(subscriber).start
  end
end
