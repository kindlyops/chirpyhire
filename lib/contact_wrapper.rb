class ContactWrapper
  include Draper::Decoratable

  def initialize(contact)
    @contact = contact
  end

  def days
    messages.by_recency.chunk(&:day).map(&method(:to_day))
  end

  def message_groups
    messages.by_recency.chunk(&:author).map(&method(:group))
  end

  def render(message)
    return render_message_group if new_message_group?(message)

    render_message(message)
  end

  attr_reader :contact

  delegate :id, :person, :messages, to: :contact
  delegate :handle, to: :person, prefix: true
  delegate :last_reply_at, to: :messages

  def recently_replied?
    last_reply_at > 24.hours.ago
  end

  private

  def to_day(day)
    Conversation::Day.new(day)
  end

  def new_message_group?(message)
    message_groups.last.messages == [message]
  end

  def group(group)
    ContactWrapper::MessageGroup.new(group)
  end

  def render_message_group
    MessagesController.render partial: 'conversations/message_group', locals: {
      message_group: message_groups.last
    }
  end

  def render_message(message)
    MessagesController.render partial: 'conversations/message', locals: {
      message: message, inbound: message.inbound?
    }
  end
end
