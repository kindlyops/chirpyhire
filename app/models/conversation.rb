class Conversation < ApplicationRecord
  belongs_to :account
  belongs_to :contact
  has_many :read_receipts

  def self.contact(contact)
    where(contact: contact)
  end
end
