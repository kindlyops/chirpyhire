class InboxConversation < ApplicationRecord
  SIDEBAR_MIN = 10
  SIDEBAR_MAX = 25

  belongs_to :account
  belongs_to :contact
  belongs_to :inbox, optional: true
  has_many :read_receipts

  delegate :handle, to: :contact

  def self.contact(contact)
    where(contact: contact)
  end

  def self.unread
    where('unread_count > ?', 0)
  end

  def self.recently_viewed
    order('inbox_conversations.last_viewed_at DESC NULLS LAST')
      .order(unread_count: :desc)
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

  private

  def to_day(day)
    Conversation::Day.new(day)
  end
end
