class Seeder::SeedContact
  def self.call(account, contact)
    new(account, contact).call
  end

  def initialize(account, contact)
    @account = account
    @contact = contact
  end

  def call
    create_sent_message('Start')
    create_received_message(thank_you) if seed_questions_and_answers
  end

  private

  delegate :organization, to: :account
  delegate :bots, to: :organization
  delegate :person, to: :bot, prefix: true

  def seed_questions_and_answers
    questions.each do |question|
      create_received_message(question.body)
      break if seed_answer(question).blank?
    end
  end

  def questions
    @questions ||= bot.questions
  end

  def bot
    @bot ||= bots.first
  end

  def seed_answer(question)
    create_sent_message(fetch_choice(question))
  end

  def fetch_choice(question)
    return zipcode if question.is_a?(ZipcodeQuestion)
    follow_ups = question.follow_ups
    follow_up = follow_ups.find { |f| f.tags.merge(contact.tags).exists? }

    follow_up.choice.to_s.upcase
  end

  def conversation
    @conversation ||= IceBreaker.call(contact, phone_number)
  end

  attr_reader :account, :contact
  delegate :organization, to: :account
  delegate :person, to: :contact

  def phone_number
    organization.phone_numbers.first
  end

  def zipcode
    contact.zipcode.zipcode
  end

  def thank_you
    Notification::ThankYou.new(contact).body
  end

  def create_sent_message(body)
    person.sent_messages.create!(
      body: body, sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'inbound',
      sender: person,
      to: phone_number.phone_number,
      from: person.phone_number,
      organization: organization
    ).tap(&method(:create_conversation_part))
  end

  def create_received_message(body)
    person.received_messages.create!(
      body: body, sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'outbound-api',
      sender: bot_person,
      from: phone_number.phone_number,
      to: person.phone_number,
      organization: organization
    ).tap(&method(:create_conversation_part))
  end

  def create_conversation_part(message)
    conversation.parts.create(
      message: message,
      happened_at: message.external_created_at
    ).tap(&:touch_conversation)
  end
end
