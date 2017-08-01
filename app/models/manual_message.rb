class ManualMessage < ApplicationRecord
  belongs_to :account

  has_many :participants, class_name: 'ManualMessageParticipant'
  has_many :unreached_participants,
           -> { unreached }, class_name: 'ManualMessageParticipant'
  has_many :messages, through: :participants
  has_many :contacts, through: :participants
  has_many :replies,  through: :participants
end
