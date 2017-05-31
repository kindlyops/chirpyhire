class ReadReceipt < ApplicationRecord
  belongs_to :message
  belongs_to :inbox_conversation

  counter_culture %i[inbox_conversation inbox],
                  column_name: proc { |model| 'unread_count' if model.unread? },
                  column_names: {
                    ['read_receipts.read_at IS NULL'] => 'unread_count'
                  }
  counter_culture :inbox_conversation,
                  column_name: proc { |model| 'unread_count' if model.unread? },
                  column_names: {
                    ['read_receipts.read_at IS NULL'] => 'unread_count'
                  }

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
