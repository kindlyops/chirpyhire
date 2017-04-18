class Broadcaster::Message
  def initialize(message)
    @message = message
  end

  def broadcast
    MessagesChannel.broadcast_to(contact, render_message)
  end

  private

  attr_reader :message

  def contact
    @contact ||= contacts.find_by(person: person)
  end

  delegate :organization, to: :message
  delegate :contacts, to: :organization

  def person
    return message.recipient if message.outbound?
    message.sender
  end

  def render_message
    Conversation.new(contact).render(message)
  end
end
