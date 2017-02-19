class Surveyor
  def initialize(subscriber)
    @subscriber = subscriber
  end

  def start
    return thank_person if candidacy.surveying?

    lock_candidacy
    survey.ask
  end

  def consider_answer(message)
    return survey.complete if survey.complete?(message)
    return survey.restate unless survey.answer.valid?(message)

    update_candidacy
    survey.ask
  end

  def survey
    @survey ||= Survey.new(candidacy)
  end

  private

  def send_message(message)
    organization.message(recipient: person, body: message)
  end

  def update_candidacy
    candidacy.update!(survey.answer.attribute(message))
  end

  def lock_candidacy
    candidacy.update!(subscriber: subscriber)
  end

  def thank_person
    send_message(thank_you.body)
  end

  def thank_you
    Notification::ThankYou.new(subscriber)
  end

  attr_reader :subscriber

  delegate :person, :organization, to: :subscriber
  delegate :candidacy, to: :person
end
