class Conversation
  include Draper::Decoratable

  def initialize(contact)
    @contact = contact
  end

  def message_groups
    messages.by_recency.chunk(&:author).map(&method(:group)).reverse
  end

  attr_reader :contact

  delegate :id, :person, :messages, to: :contact
  delegate :handle, to: :person, prefix: true
  delegate :last_reply_at, to: :messages

  def recently_replied?
    last_reply_at > 24.hours.ago
  end

  private

  def group(group)
    Conversation::MessageGroup.new(group)
  end
end
