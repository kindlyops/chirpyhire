class Conversation < ApplicationRecord
  SIDEBAR_MIN = 10
  belongs_to :account
  belongs_to :contact
  has_many :read_receipts

  def self.contact(contact)
    where(contact: contact)
  end

  def self.current
    order(last_viewed_at: :desc)
  end

  def self.unread
    where('unread_count > ?', 0)
  end

  def self.recently_viewed
    order(last_viewed_at: :asc)
  end

  def self.by_handle
    order('COALESCE(people.name, people.nickname) ASC')
  end

  def self.read
    where(unread_count: 0)
  end

  def self.sidebar
    viewed_recently = joins(contact: :person).recently_viewed.by_handle
    limit_count = [3, SIDEBAR_MIN - unread.count].max

    viewed_recently.read.limit(limit_count) + unread
  end

  def days
    messages.by_recency.chunk(&:day).map(&method(:to_day))
  end

  def unread?
    unread_count.positive?
  end

  def read?
    !unread?
  end

  delegate :messages, to: :contact

  private

  def to_day(day)
    Conversation::Day.new(day)
  end
end
