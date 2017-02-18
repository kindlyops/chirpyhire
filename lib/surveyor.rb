class Surveyor
  def initialize(subscriber)
    @subscriber = subscriber
  end

  def call
    return thank_person if candidacy.surveyed?

    lock_candidacy
    survey.ask
  end

  private

  def survey
    Survey.new(candidacy)
  end

  def lock_candidacy
    candidacy.update!(subscriber: subscriber)
  end

  def thank_person
    organization.message(recipient: person, body: thank_you)
  end

  def thank_you
    Question::ThankYou.new(subscriber).to_s
  end

  attr_reader :subscriber

  delegate :person, :organization, to: :subscriber
  delegate :candidacy, to: :person
end
