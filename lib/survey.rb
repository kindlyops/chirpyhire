class Survey
  def initialize(contact, message)
    @contact = contact
    @message = message
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

  def just_finished?
    return unless candidacy.in_progress?

    last_question? && answer.valid?(message)
  end

  delegate :answer, to: :current_question

  def questions
    @questions ||= Survey::Questions.call(contact)
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

  def send_message(message_body)
    organization.message(
      sender: Chirpy.person,
      conversation: message.conversation,
      body: message_body
    )
  end

  def current_question
    @current_question ||= questions[candidacy.inquiry]
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

  def candidacy
    contact.contact_candidacy
  end

  def keys
    questions.keys.map(&:to_sym)
  end

  attr_reader :contact, :message
  delegate :organization, to: :contact
end
