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
    create_received_message(thank_you)
  end

  private

  def conversation
    @conversation ||= IceBreaker.call(contact, phone_number)
  end

  attr_reader :account, :contact
  delegate :organization, to: :account
  delegate :person, to: :contact

  def phone_number
    organization.phone_numbers.first
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
