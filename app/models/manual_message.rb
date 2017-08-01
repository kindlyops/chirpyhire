class ManualMessage < ApplicationRecord
  belongs_to :account

  has_many :contacts_manual_messages
  has_many :messages, through: :contacts_manual_messages
  has_many :contacts, through: :contacts_manual_messages
  has_many :replies,  through: :contacts_manual_messages
end
