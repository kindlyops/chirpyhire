class Inbox::ConversationSerializer
  def initialize(inbox_conversation)
    @inbox_conversation = inbox_conversation
  end

  def call
    Jbuilder.new(&method(:build))
  end

  delegate :attributes!, to: :call
  delegate :id, :contact, :unread_count, to: :inbox_conversation

  private

  def build(json)
    json.id id
    json.contact_id contact.id
    json.handle contact.handle
    json.unread_count unread_count

    add_message(json) if message.present?
  end

  attr_reader :inbox_conversation

  def add_message(json)
    json.timestamp message.conversation_day.label
    json.summary message.summary
  end

  def message
    @message ||= inbox_conversation.messages.by_recency.first
  end
end
