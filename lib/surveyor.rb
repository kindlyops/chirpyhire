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

  private

  def update_candidacy
    candidacy.update!(survey.answer.attribute(message))
  end

  def survey
    Survey.new(candidacy)
  end

  def lock_candidacy
    candidacy.update!(subscriber: subscriber)
  end

  def thank_person
    organization.message(recipient: person, body: thank_you.body)
  end

  def thank_you
    Notification::ThankYou.new(subscriber)
  end

  attr_reader :subscriber

  delegate :person, :organization, to: :subscriber
  delegate :candidacy, to: :person
end
