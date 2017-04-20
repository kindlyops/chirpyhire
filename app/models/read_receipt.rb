class ReadReceipt < ApplicationRecord
  belongs_to :message
  belongs_to :conversation

  counter_culture [:conversation, :account],
                  column_name: proc { |model| 'unread_count' if model.unread? }
  counter_culture :conversation,
                  column_name: proc { |model| 'unread_count' if model.unread? }

  def self.unread
    where(read_at: nil)
  end

  def unread?
    read_at.blank?
  end

  def read?
    !unread?
  end
end
