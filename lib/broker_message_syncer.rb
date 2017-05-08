class BrokerMessageSyncer
  def initialize(broker_contact, message_sid)
    @broker_contact = broker_contact
    @message_sid    = message_sid
  end

  def call
    existing_message = person.sent_messages.find_by(sid: message_sid)
    return existing_message if existing_message.present?
    message = sync_message
    broker_contact.update(last_reply_at: message.created_at)
    message
  end

  private

  def external_message
    broker.get_message(message_sid)
  end

  attr_reader :broker_contact, :message_sid, :receipt
  delegate :person, :broker, to: :broker_contact

  def sync_message
    person.sent_messages.create!(
      sid: external_message.sid,
      body: external_message.body,
      direction: external_message.direction,
      sent_at: external_message.date_sent,
      external_created_at: external_message.date_created,
      broker: broker
    )
  end
end
