class Survey
  LAST_QUESTION = :certification

  def initialize(candidacy)
    @candidacy = candidacy
  end

  def ask
    candidacy.update!(inquiry: next_question.inquiry)
    send_message(next_question.body)
  end

  def restate
    send_message(current_question.restated)
  end

  def complete
    candidacy.update!(inquiry: nil)
    send_message(thank_you.body)
  end

  def complete?(message)
    answer.valid?(message) && last_question?
  end

  delegate :answer, to: :current_question

  private

  def last_question?
    current_question.inquiry == LAST_QUESTION
  end

  def send_message(message)
    organization.message(recipient: person, body: message)
  end

  def current_question
    questions[candidacy.inquiry]
  end

  def next_question
    question_after[candidacy.inquiry]
  end

  def question_after
    {
      nil => experience,
      experience: skin_test,
      skin_test: availability,
      availability: transportation,
      transportation: zipcode,
      zipcode: cpr_first_aid,
      cpr_first_aid: certification
    }
  end

  def questions
    {
      experience: experience,
      skin_test: skin_test,
      availability: availability,
      transportation: transportation,
      zipcode: zipcode,
      cpr_first_aid: cpr_first_aid,
      certification: certification
    }
  end

  def experience
    Question::Experience.new(subscriber)
  end

  def skin_test
    Question::SkinTest.new(subscriber)
  end

  def availability
    Question::Availability.new(subscriber)
  end

  def transportation
    Question::Transportation.new(subscriber)
  end

  def zipcode
    Question::Zipcode.new(subscriber)
  end

  def cpr_first_aid
    Question::CprFirstAid.new(subscriber)
  end

  def certification
    Question::Certification.new(subscriber)
  end

  def thank_you
    Notification::ThankYou.new(subscriber)
  end

  attr_reader :candidacy
  delegate :subscriber, to: :candidacy
  delegate :person, :organization, to: :subscriber
end
