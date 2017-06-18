class ReadReceipt < ApplicationRecord
  belongs_to :message
  belongs_to :conversation, optional: true

  def self.unread
    where(read_at: nil)
  end

  def self.after(receipt)
    where('created_at > ?', receipt.created_at)
  end

  def read
    update(read_at: DateTime.current)
  end

  def unread?
    read_at.blank?
  end

  def read?
    !unread?
  end
end
