class BrokerSurvey
  LAST_QUESTION = :skin_test

  def initialize(broker_candidacy)
    @broker_candidacy = broker_candidacy
  end

  def ask
    return unless broker_candidacy.in_progress?

    broker_candidacy.update!(inquiry: next_question.inquiry)
    send_message(next_question.body)
  end

  def on?(inquiry)
    broker_candidacy.in_progress? && broker_candidacy.inquiry == inquiry.to_s
  end

  def restate
    return unless broker_candidacy.in_progress?

    send_message(current_question.restated)
  end

  def complete
    return unless broker_candidacy.in_progress?

    broker_candidacy.update!(inquiry: nil, state: :complete)
    send_message(thank_you.body)
  end

  def just_finished?(message)
    return unless broker_candidacy.in_progress?

    last_question? && answer.valid?(message)
  end

  delegate :answer, to: :current_question

  def questions
    {
      certification: certification,
      availability: availability,
      experience: experience,
      transportation: transportation,
      zipcode: zipcode,
      cpr_first_aid: cpr_first_aid,
      skin_test: skin_test
    }.with_indifferent_access
  end

  private

  def last_question?
    current_question.inquiry == LAST_QUESTION
  end

  def send_message(message)
    broker.message(
      sender: Chirpy.person,
      recipient: person,
      body: message
    )
  end

  def current_question
    @current_question ||= questions[broker_candidacy.inquiry]
  end

  def next_question
    @next_question ||= question_after[broker_candidacy.inquiry]
  end

  def question_after
    {
      nil => certification,
      certification: availability,
      availability: experience,
      experience: transportation,
      transportation: zipcode,
      zipcode: cpr_first_aid,
      cpr_first_aid: skin_test
    }.with_indifferent_access
  end

  def experience
    Question::Experience.new(broker_contact)
  end

  def skin_test
    Question::SkinTest.new(broker_contact)
  end

  def availability
    Question::Availability.new(broker_contact)
  end

  def transportation
    Question::Transportation.new(broker_contact)
  end

  def zipcode
    Question::Zipcode.new(broker_contact)
  end

  def cpr_first_aid
    Question::CprFirstAid.new(broker_contact)
  end

  def certification
    Question::Broker::Certification.new(broker_contact)
  end

  def thank_you
    Notification::Broker::ThankYou.new(broker_contact)
  end

  attr_reader :broker_candidacy
  delegate :broker_contact, to: :broker_candidacy
  delegate :person, :broker, to: :broker_contact
end