class InboxConversation < ApplicationRecord
  SIDEBAR_MIN = 10
  SIDEBAR_MAX = 25

  belongs_to :contact
  belongs_to :inbox
  has_many :read_receipts

  delegate :handle, to: :contact
  delegate :account, to: :inbox

  def self.contact(contact)
    where(contact: contact)
  end

  def self.unread
    where('inbox_conversations.unread_count > ?', 0)
  end

  def self.recently_viewed
    order('inbox_conversations.last_viewed_at DESC NULLS LAST')
      .order('inbox_conversations.unread_count DESC')
  end

  def self.by_handle
    order('NULLIF(people.name, people.nickname) ASC')
  end

  def self.read
    where(unread_count: 0)
  end

  def self.sidebar
    viewed_recently = joins(contact: :person).recently_viewed
    limit_count = [3, SIDEBAR_MIN - unread.count].max

    sidebar = (viewed_recently.read.limit(limit_count) + unread)
    sidebar.sort_by(&:handle).take(SIDEBAR_MAX)
  end

  def days
    messages.by_recency.chunk(&:day).map(&method(:to_day))
  end

  def day(date)
    result = messages.by_recency.chunk(&:day).find do |day, _|
      day == date
    end

    to_day(result)
  end

  def unread?
    unread_count.positive?
  end

  def read?
    !unread?
  end

  delegate :messages, :person, to: :contact
  delegate :handle, to: :person, prefix: true

  def to_builder
    Inbox::ConversationSerializer.new(self)
  end

  private

  def to_day(day)
    Conversation::Day.new(day)
  end
end
