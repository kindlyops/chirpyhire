class Question < ApplicationRecord
  belongs_to :survey
  has_many :inquiries
  enum status: [:active, :inactive]

  delegate :bad_fit, to: :survey
  validates_presence_of :text, :label, :status, :priority

  TYPES = %w(ChoiceQuestion AddressQuestion DocumentQuestion)
  validates_inclusion_of :type, in: TYPES

  def self.by_priority
    order(:priority)
  end

  def inquire(user)
    message = user.receive_message(body: question)
    inquiries.create(message: message)
  end

  def question
    text
  end
end
