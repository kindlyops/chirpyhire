class Brokers::AnswersController < Brokers::MessagesController
  def create
    BrokerSurveyorAnswerJob.perform_later(
      broker_contact,
      inquiry,
      params['MessageSid']
    )

    head :ok
  end

  private

  def inquiry
    broker_contact.broker_candidacy_inquiry
  end
end
