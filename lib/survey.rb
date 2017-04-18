class Survey
  LAST_QUESTION = :skin_test

  def initialize(candidacy)
    @candidacy = candidacy
  end

  def ask
    return unless candidacy.in_progress?

    candidacy.update!(inquiry: next_question.inquiry)
    send_message(next_question.body)
  end

  def on?(inquiry)
    candidacy.in_progress? && candidacy.inquiry == inquiry.to_s
  end

  def restate
    return unless candidacy.in_progress?

    send_message(current_question.restated)
  end

  def complete
    return unless candidacy.in_progress?

    candidacy.update!(inquiry: nil, state: :complete)
    candidacy.contacts.find_each { |contact| contact.update(candidate: true) }
    send_message(thank_you.body)
  end

  def just_finished?(message)
    return unless candidacy.in_progress?

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
    organization.message(sender: Chirpy.person, recipient: person, body: message)
  end

  def current_question
    @current_question ||= questions[candidacy.inquiry]
  end

  def next_question
    @next_question ||= question_after[candidacy.inquiry]
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
    Question::Experience.new(contact)
  end

  def skin_test
    Question::SkinTest.new(contact)
  end

  def availability
    Question::Availability.new(contact)
  end

  def transportation
    Question::Transportation.new(contact)
  end

  def zipcode
    Question::Zipcode.new(contact)
  end

  def cpr_first_aid
    Question::CprFirstAid.new(contact)
  end

  def certification
    Question::Certification.new(contact)
  end

  def thank_you
    Notification::ThankYou.new(contact)
  end

  attr_reader :candidacy
  delegate :contact, to: :candidacy
  delegate :person, :organization, to: :contact
end
