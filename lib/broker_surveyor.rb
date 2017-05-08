class BrokerSurveyor
  def initialize(broker_contact)
    @broker_contact = broker_contact
  end

  def start
    start_survey if broker_candidacy.pending?
  end

  def consider_answer(inquiry, message)
    return unless broker_survey.on?(inquiry)

    return complete_broker_survey(message) if just_finished?(message)
    return broker_survey.restate unless broker_survey.answer.valid?(message)

    update_broker_candidacy(message)
    broker_survey.ask
  end

  def broker_survey
    @broker_survey ||= BrokerSurvey.new(broker_candidacy)
  end

  private

  def start_survey
    lock_broker_candidacy
    broker_survey.ask
  end

  def complete_broker_survey(message)
    update_broker_candidacy(message)
    broker_survey.complete
  end

  def send_message(message)
    broker.message(
      sender: Chirpy.person,
      recipient: person,
      body: message
    )
  end

  def update_broker_candidacy(message)
    broker_survey.answer.format(message) do |formatted_answer|
      broker_candidacy.assign_attributes(formatted_answer)
      broker_candidacy.save!
    end
  end

  def lock_broker_candidacy
    broker_candidacy.update!(
      broker_contact: broker_contact,
      state: :in_progress
    )
  end

  attr_reader :broker_contact
  delegate :just_finished?, to: :broker_survey
  delegate :person, :broker, to: :broker_contact
  delegate :broker_candidacy, to: :person
end
