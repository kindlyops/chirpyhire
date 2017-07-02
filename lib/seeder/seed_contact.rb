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
    seed_zipcode
  end

  private

  def seed_zipcode
    return if contact_candidacy.blank? || contact_candidacy.zipcode.blank?
    ZipcodeFetcher.call(contact, contact_candidacy.zipcode)
  end

  def seed_questions_and_answers
    questions.each do |category, question|
      create_received_message(question.body)
      answer = seed_answer(category, question)
      break if answer.blank?
    end
  end

  def questions
    @questions ||= Survey::Questions.call(contact)
  end

  def conversation
    @conversation ||= IceBreaker.call(contact, phone_number)
  end

  attr_reader :account, :contact
  delegate :organization, to: :account
  delegate :person, :contact_candidacy, to: :contact

  def phone_number
    organization.phone_numbers.first
  end

  def seed_answer(category, question)
    choice = fetch_choice(category)
    return if choice.nil?
    answer = fetch_answer(category, question)
    create_sent_message(answer_body(answer, choice, category))
  end

  def fetch_answer(category, question)
    "Answer::#{category.camelcase}".constantize.new(question)
  end

  def fetch_choice(category)
    choice = contact.contact_candidacy.send(category.to_sym)
    return choice.to_sym if choice.respond_to?(:to_sym)
    choice
  end

  def answer_body(answer, choice, category)
    return zipcodes.sample if category == 'zipcode'
    answer.question.choices.invert[answer.choice_map.invert[choice]]
  end

  def zipcodes
    %w[30319 30324 30327 30328 30329
       30338 30339 30340 30341 30342]
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
      conversation: conversation
    ).tap(&:touch_conversation)
  end

  def create_received_message(body)
    person.received_messages.create!(
      body: body, sid: SecureRandom.uuid,
      sent_at: DateTime.current,
      external_created_at: DateTime.current,
      direction: 'outbound-api',
      sender: Chirpy.person,
      from: phone_number.phone_number,
      to: person.phone_number,
      conversation: conversation
    ).tap(&:touch_conversation)
  end
end
