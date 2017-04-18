class Conversation < ApplicationRecord
  SIDEBAR_MIN = 10
  belongs_to :account
  belongs_to :contact
  has_many :read_receipts

  def self.contact(contact)
    where(contact: contact)
  end

  def self.unread
    where('unread_count > ?', 0)
  end

  def unread?
    unread_count.positive?
  end

  def read?
    !unread?
  end

  def self.recently_replied
    order('conversations.unread_count DESC, '\
          'contacts.last_reply_at DESC, '\
          'COALESCE(people.name, people.nickname) ASC')
  end

  def self.sidebar
    if unread.count > SIDEBAR_MIN
      unread.order(:handle)
    else
      joins(contact: :person).recently_replied.limit(SIDEBAR_MIN - unread.count)
    end
  end
end
