# frozen_string_literal: true
class Question < ApplicationRecord
  belongs_to :survey
  has_many :inquiries
  enum status: [:active, :inactive]

  delegate :bad_fit, to: :survey
  validates :text, :label, :status, :priority, presence: true

  TYPES = %w(ChoiceQuestion
             AddressQuestion
             DocumentQuestion
             YesNoQuestion).freeze

  validates :type, inclusion: { in: TYPES }

  def self.by_priority
    order(:priority)
  end

  def rejects?(_candidate)
    false
  end

  def inquire(user, message_text: formatted_text)
    message = user.receive_message(body: message_text)
    inquiries.create(message: message)
  end

  def formatted_text
    text
  end
end
