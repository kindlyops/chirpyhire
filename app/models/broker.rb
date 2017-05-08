class Broker < ApplicationRecord
  phony_normalize :phone_number, default_country_code: 'US'
  has_many :messages

  def get_message(sid)
    messaging_client.messages.get(sid)
  end

  def message(recipient:, body:, sender: nil)
    sent_message = messaging_client.send_message(
      to: recipient.phone_number, from: phone_number, body: body
    )

    create_message(recipient, sent_message, sender)
  end

  private

  def create_message(recipient, message, sender)
    messages.create(
      sid: message.sid,
      body: message.body,
      sent_at: message.date_sent,
      external_created_at: message.date_created,
      direction: message.direction,
      sender: sender,
      recipient: recipient
    )
  end

  def messaging_client
    @messaging_client ||= Messaging::Client.new(self)
  end
end
