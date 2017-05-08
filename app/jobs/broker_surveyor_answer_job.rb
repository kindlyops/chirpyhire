class BrokerSurveyorAnswerJob < ApplicationJob
  def perform(broker_contact, inquiry, message_sid)
    message = BrokerMessageSyncer.new(broker_contact, message_sid).call

    BrokerSurveyor.new(broker_contact).consider_answer(inquiry, message)
  end
end
