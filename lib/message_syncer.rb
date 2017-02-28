class MessageSyncer
  def initialize(person, organization, message_sid)
    @person       = person
    @organization = organization
    @message_sid  = message_sid
  end

  def call
    existing_message = person.messages.find_by(sid: message_sid)
    return existing_message if existing_message.present?
    broadcast(sync_message)
  end

  private

  def external_message
    organization.get_message(message_sid)
  end

  attr_reader :person, :message_sid, :organization

  def sync_message
    person.messages.create!(
      sid: external_message.sid,
      body: external_message.body,
      direction: external_message.direction,
      sent_at: external_message.date_sent,
      external_created_at: external_message.date_created,
      organization: organization
    )
  end

  def broadcast(message)
    contact = organization.contacts.find_by(person: person)
    rendered_message = render_message(contact, message)
    MessagesChannel.broadcast_to(contact, rendered_message)
    message
  end

  def render_message(contact, message)
    Conversation.new(contact).render(message)
  end
end
