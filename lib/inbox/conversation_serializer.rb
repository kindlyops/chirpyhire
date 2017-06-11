class Inbox::ConversationSerializer
  def initialize(inbox_conversation)
    @inbox_conversation = inbox_conversation
  end

  def call
    Jbuilder.new(&method(:build))
  end

  delegate :attributes!, to: :call
  delegate :unread_count, :conversation, to: :inbox_conversation
  delegate :id, :contact, to: :conversation

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
    json.timestamp timestamp
    json.summary message.summary
  end

  def timestamp
    conversation.decorate.last_message_created_at.label
  end

  def message
    @message ||= conversation.recent_message
  end
end
