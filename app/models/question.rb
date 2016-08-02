class Question < ApplicationRecord
  belongs_to :survey
  belongs_to :category
  has_many :inquiries
  enum status: [:active, :inactive]

  delegate :template, to: :survey
  delegate :name, to: :category, prefix: true

  TYPES = %w(ChoiceQuestion AddressQuestion DocumentQuestion)
  validates_inclusion_of :type, in: TYPES

  def inquire(user)
    message = user.receive_message(body: text)
    inquiries.create(message: message)
  end

  def question
    text
  end
end
