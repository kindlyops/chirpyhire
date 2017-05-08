class BrokerSurveyorJob < ApplicationJob
  def perform(broker_contact)
    BrokerSurveyor.new(broker_contact).start
  end
end
