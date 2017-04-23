class Conversation < ApplicationRecord
  SIDEBAR_MIN = 10
  belongs_to :account
  belongs_to :contact
  has_many :read_receipts
  has_many :notes

  delegate :handle, to: :contact

  def self.contact(contact)
    where(contact: contact)
  end

  def self.unread
    where('unread_count > ?', 0)
  end

  def self.recently_viewed
    order('conversations.last_viewed_at DESC NULLS LAST')
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

    (viewed_recently.read.limit(limit_count) + unread).sort_by(&:handle)
  end

  def note_days
    notes.by_recency.chunk(&:day).map(&method(:to_note_day))
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

  def to_note_day(day)
    Conversation::NoteDay.new(day)
  end

  def to_day(day)
    Conversation::Day.new(day)
  end
end
