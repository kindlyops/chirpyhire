class MessageSyncer
  def initialize(person, organization, message_sid)
    @person       = person
    @organization = organization
    @message_sid  = message_sid
  end

  def call
    existing_message = person.messages.find_by(sid: message_sid)
    return existing_message if existing_message.present?
    message = sync_message
    update_contact(message)
    Broadcaster::Message.new(message).broadcast
    message
  end

  private

  def external_message
    organization.get_message(message_sid)
  end

  attr_reader :person, :message_sid, :organization

  def sync_message
    person.messages.create!(external_message_details.merge(
                              organization: organization,
                              recipient: organization.recruiter_person,
                              sender: person
    ))
  end

  def external_message_details
    {
      sid: external_message.sid,
      body: external_message.body,
      direction: external_message.direction,
      sent_at: external_message.date_sent,
      external_created_at: external_message.date_created
    }
  end

  def update_contact(message)
    contact = person.contacts.find_by(organization: organization)
    contact.update(last_reply_at: message.created_at)
    Broadcaster::LastReply.new(contact).broadcast
    Broadcaster::Temperature.new(contact).broadcast
  end
end
