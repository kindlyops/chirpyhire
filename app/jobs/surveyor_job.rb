class SurveyorJob < ApplicationJob
  def perform(contact)
    Surveyor.new(contact).start
  end
end
