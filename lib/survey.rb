class Survey
  def initialize(candidacy)
    @candidacy = candidacy
  end

  def ask(welcome: false)
    return unless candidacy.in_progress?

    candidacy.update!(inquiry: next_question.inquiry)
    send_message(next_question.body(welcome: welcome))
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
    contact.update!(screened: true)
    candidacy.update!(inquiry: nil, state: :complete)
    send_message(thank_you.body)
  end

  def just_finished?(message)
    return unless candidacy.in_progress?

    last_question? && answer.valid?(message)
  end

  delegate :answer, to: :current_question

  def questions
    Hash[keys.map do |key|
      question = "Question::#{key.to_s.camelcase}".constantize.new(contact)
      [key, question]
    end].with_indifferent_access
  end

  def next_question
    @next_question ||= question_after(candidacy.inquiry)
  end

  def last_question?
    return true if last_question.blank?
    current_question.inquiry == last_question
  end

  def last_question
    keys.reverse.find do |question|
      active?(question)
    end
  end

  private

  def send_message(message)
    organization.message(
      sender: Chirpy.person,
      contact: contact,
      body: message
    )
  end

  def current_question
    @current_question ||= questions[candidacy.inquiry]
  end

  def keys
    %i[certification availability live_in experience
       transportation zipcode cpr_first_aid skin_test]
  end

  def question_after(inquiry)
    key = fetch_key(inquiry)
    questions[key.to_sym]
  end

  def fetch_key(inquiry)
    keys.find do |question|
      after?(question, inquiry) && active?(question)
    end
  end

  def after?(question, inquiry)
    return true if inquiry.blank?
    keys.find_index(question) > keys.find_index(inquiry.to_sym)
  end

  def active?(question)
    organization.send("#{question}?")
  end

  def thank_you
    Notification::ThankYou.new(contact)
  end

  attr_reader :candidacy
  delegate :contact, to: :candidacy
  delegate :organization, to: :contact
end
