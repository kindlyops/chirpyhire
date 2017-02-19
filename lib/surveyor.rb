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
    return complete_survey(message) if survey.complete?(message)
    return survey.restate unless survey.answer.valid?(message)

    update_candidacy(message)
    survey.ask
  end

  def survey
    @survey ||= Survey.new(candidacy)
  end

  private

  def complete_survey(message)
    update_candidacy(message)
    survey.complete
  end

  def send_message(message)
    organization.message(recipient: person, body: message)
  end

  def update_candidacy(message)
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
