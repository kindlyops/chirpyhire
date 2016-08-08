class Question < ApplicationRecord
  belongs_to :survey
  has_many :inquiries
  enum status: [:active, :inactive]

  delegate :template, to: :survey

  TYPES = %w(ChoiceQuestion AddressQuestion DocumentQuestion)
  validates_inclusion_of :type, in: TYPES

  def inquire(user)
    message = user.receive_message(body: question)
    inquiries.create(message: message)
  end

  def question
    text
  end
end
