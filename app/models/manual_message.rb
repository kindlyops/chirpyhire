class ManualMessage < ApplicationRecord
  belongs_to :account

  has_many :messages
  has_many :recipients, through: :messages
  has_many :contacts, through: :recipients

  has_many :replies, class_name: 'ManualMessageReply'
end
